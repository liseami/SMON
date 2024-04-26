//
//  IAPManager.swift
//  StomachBook
//
//  Created by 赵翔宇 on 2024/4/3.
//

import Foundation

import JDStatusBarNotification
import StoreKit
import SwiftUIX

class IAPManager: NSObject, SKPaymentTransactionObserver, ObservableObject {
    private let productIdentifiers = Set<String>([
        "001", "002", "003", "004", "005", "006"
    ])
    @Published var products = [SKProduct]()
    
    static let shared = IAPManager()
    
    override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    /*
     购买产品
     */
    
    @MainActor
    func buy(productId: String) {
        guard let p = products.first(where: { $0.productIdentifier == productId }) else {
            Apphelper.shared.pushNotification(type: .error(message: "没有相关产品。"))
            return
        }
        appleStartBuy()
        purchase(product: p)
    }
    
    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    var layerView = VisualEffectBlurView(blurStyle: .light)
        .edgesIgnoringSafeArea(.all).host().view!
    
    @MainActor func appleStartBuy() {
        guard let window = Apphelper.shared.getWindow() else { return }
        
        // 创建模糊效果的视图
        
        layerView.size = CGSize(width: Screen.main.bounds.width, height: Screen.main.bounds.height)
        layerView.backgroundColor = UIColor.clear
        layerView.alpha = 0.0 // 初始时设置为透明
        layerView.tag = 1
        layerView.center = CGPoint(x: Screen.main.bounds.width * 0.5, y: Screen.main.bounds.height * 0.5)
            
        // 将模糊效果的视图添加到窗口上
        window.addSubview(layerView)
            
        // 显示loading消息
        Apphelper.shared.pushNotification(type: .loading(message: " 🍎 连接Apple"))
            
        // 使用UIView.animate实现渐显动画
        UIView.animate(withDuration: 1) {
            self.layerView.alpha = 1.0 // 设置为完全不透明
        }
    }
    
    func appleEndBuy() {
        // 异步执行任务
        // 使用UIView.animate实现淡出动画
        UIView.animate(withDuration: 0.3) {
            self.layerView.alpha = 0.0 // 设置为透明
        } completion: { _ in
            self.layerView.removeFromSuperview() // 移除模糊效果的视图
//            NotificationPresenter.shared.dismiss() // 关闭loading消息
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    struct OrderInfo: Convertible {
        var orderId: String = ""
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // 交易已完成
                completeTransaction(transaction)
                // 打印购买凭证信息
                appleEndBuy()
            // 支付失败
            case .failed:
                failedTransaction(transaction)
                appleEndBuy()
                DispatchQueue.main.async {
                    Apphelper.shared.pushNotification(type: .info(message: "交易取消，请重试。"))
                }
            case .restored:
                restoreTransaction(transaction)
                appleEndBuy()
            // 正在支付
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        DispatchQueue.main.async {
            LoadingTask(loadingMessage: "与大赛支付中心进行确认") {
                let t = OrderAPI.placeOrder(payType: 21, goodsId: transaction.payment.productIdentifier)
                let r = await Networking.request_async(t)
                if r.is2000Ok, let mod = r.mapObject(OrderInfo.self) {
                    await waitme(sec: 1)
                    if let receiptStr = self.printReceipt() {
                        let t2 = OrderAPI.iosPayVerify(transactionId: transaction.transactionIdentifier ?? "", receipt: receiptStr, orderId: mod.orderId)
                        let r2 = await Networking.request_async(t2)
                        if r2.is2000Ok {
                            await UserManager.shared.getUserInfo()
                            Apphelper.shared.pushNotification(type: .success(message: "充值成功！大吉大利！祝你吃鸡！"))
                            NotificationCenter.default.post(name: Notification.Name.IAP_BUY_SUCCESS, object: nil, userInfo: nil)
                        }
                    }
                }
            }
        }
    }
    
    private func failedTransaction(_ transaction: SKPaymentTransaction) {
        if let error = transaction.error {
            print("Transaction failed: \(error.localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restoreTransaction(_ transaction: SKPaymentTransaction) {
        // Restore non-consumable purchases if needed
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func printReceipt() -> String? {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL)
                let receiptString = receiptData.base64EncodedString(options: [])
                /*
                 收据打印
                 */
                print(receiptString)
                return receiptString
            } catch {
                return nil
                print("Couldn't read receipt data with error: " + error.localizedDescription)
            }
        }
        return nil
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to fetch products: \(error.localizedDescription)")
    }
}
