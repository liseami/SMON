//
//  CoinshopView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import StoreKit
import SwiftUI
import SwiftUIX
import SwiftyStoreKit

struct XMProduct: Convertible, Identifiable {
    var id: String = "" //
    var title: String = "" // ": "5赛币",
    var titleDesc: String = "" // ": "",
    var coverUrl: String = "" // ": "app/goods/3d-blocks-blocks-composition-48.png",
    var goodsCode: String = "" // ": "001",
    var price: String = "" // ": 1.00
}

class StoreManager: XMListViewModel<XMProduct> {
    @Published private(set) var activeTransactions: Set<StoreKit.Transaction> = []

    private var updates: Task<Void, Never>?

    init() {
        super.init(target: GoodAPI.getCoinList, atKeyPath: .data)
        Task {
            await self.getListData()
            await self.getUserWallet()
        }
        updates = Task {
            // 监听购买活动
            for await update in StoreKit.Transaction.updates {
                if let transaction = try? update.payloadValue {
                    await fetchActiveTransactions()
                    await transaction.finish()
                    print("交易ID:" + "\(transaction.id)")
                }
            }
        }
    }

    struct UserWallet: Convertible {
        var coinNum: String = "0"
    }

    @Published var wallet: UserWallet = .init()
    @MainActor func getUserWallet() async {
        let t = UserAPI.wallet
        let r = await Networking.request_async(t)
        if r.is2000Ok, let wallet = r.mapObject(UserWallet.self) {
            self.wallet = wallet
        }
    }

    deinit {
        updates?.cancel()
    }

    @MainActor
    func fetchProducts(id: String) async -> Product? {
        do {
            let products = try await Product.products(
                for: ["001", "002", "003", "004", "005", "006"]
            )
            print(products.isEmpty ? "没有查找到产品。" : products)
            return products.first
        } catch {
            print("没有产品。")
            return nil
        }
    }

    /// 买产品
    func buyProduct(id: String) {
//
//        SwiftyStoreKit.
    }

    // 发起购买
    @MainActor
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            if let transaction = try? verificationResult.payloadValue {
                activeTransactions.insert(transaction)
                await transaction.finish()
            }
        case .userCancelled:
            Apphelper.shared.pushNotification(type: .info(message: "购买已取消。"))
        case .pending:
            Apphelper.shared.pushNotification(type: .info(message: "支付成功。请刷新赛币额。"))
            break
        @unknown default:
            break
        }
    }

    // 寻找活动的交易
    func fetchActiveTransactions() async {
        var activeTransactions: Set<StoreKit.Transaction> = []
        for await entitlement in StoreKit.Transaction.currentEntitlements {
            if let transaction = try? entitlement.payloadValue {
                activeTransactions.insert(transaction)
            }
        }
        self.activeTransactions = activeTransactions
    }
}

struct CoinshopView: View {
    @StateObject var vm: StoreManager = .init()

    var body: some View {
        VStack(alignment: .center, spacing: 24, content: {
            Spacer().frame(height: 1)
            HStack(content: {
                Text("赛币充值").font(.title3.bold())
                Spacer()
                HStack(alignment: .center, spacing: 12, content: {
                    Text("\(vm.wallet.coinNum) 赛币(余额)")
                        .font(.XMFont.f1b)
                })
            })
            products
            Text(LocalizedStringKey("点击支付，即代表您已阅读并同意「每日大赛」的[《赛币充值协议》](https://www.baidu.com)。"))
                .font(.XMFont.f2)
                .multilineTextAlignment(.leading)
                .fcolor(.XMDesgin.f2)
                .tint(Color.XMDesgin.main)
                .environment(\.openURL, OpenURLAction { _ in
                    .handled
                })
        })
        .task {
            if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
               FileManager.default.fileExists(atPath: appStoreReceiptURL.path)
            {
                do {
                    let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                    print(receiptData)

                    let receiptString = receiptData.base64EncodedString(options: [])
                    print(receiptString)
                    // Read ReceiptData
                } catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
            } else {
                print("没有票据")
            }
        }
        .padding(.all)
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(height: UIScreen.main.bounds.height * 0.7, alignment: .top)
//        .background(Color.red)
    }

    var products: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            XMStateView(vm.list, reqStatus: vm.reqStatus) { product in
                let productUI = VStack(alignment: .center, spacing: 0, content: {
                    VStack(alignment: .center, spacing: 12, content: {
                        WebImage(str: product.coverUrl)
                            .frame(width: 56, height: 56, alignment: .center)
                        Text(product.title)
                            .font(.XMFont.big3.bold())
                    })
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.black)
                    VStack(alignment: .center, spacing: 3, content: {
                        Text("¥\(product.price)")
                            .font(.XMFont.f1b)
                            .fcolor(Color.green)
                    })
                    .padding(.vertical, 8)
                })
                .overlay(alignment: .center) {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1.5)
                        .fcolor(.XMDesgin.f3)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.all, 1)

                XMDesgin.XMButton {
                    LoadingTask(loadingMessage: "连接苹果商店...") {
                        if let p = await vm.fetchProducts(id: product.goodsCode) {
                            do {
                                try await vm.purchase(p)
                            } catch {
                                Apphelper.shared.pushNotification(type: .error(message: "购买失败请重试。"))
                            }
                        } else {
                            Apphelper.shared.pushNotification(type: .error(message: "产品不存在。"))
                        }
                    }
                } label: {
                    productUI
                }
            } loadingView: {
                ProgressView()
            } emptyView: {
                EmptyView()
            }
        }
    }
}

#Preview {
    CoinshopView()
}
