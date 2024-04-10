//
//  IAPManager.swift
//  StomachBook
//
//  Created by 赵翔宇 on 2024/4/3.
//

import Foundation

import StoreKit

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
    
    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
                printReceipt(transaction)
            case .failed:
                failedTransaction(transaction)
            case .restored:
                restoreTransaction(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
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
    
    private func printReceipt(_ transaction: SKPaymentTransaction) {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL)
                let receiptString = receiptData.base64EncodedString(options: [])
                
            } catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
        } else {}
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to fetch products: \(error.localizedDescription)")
    }
}
