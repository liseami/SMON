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
    init() {
        super.init(target: GoodAPI.getCoinList, atKeyPath: .data)
        Task {
            await self.getListData()
            await self.getUserWallet()
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
}

struct CoinshopView: View {
    @StateObject var vm: StoreManager = .init()
    @StateObject var iapmanager: IAPManager = .init()
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
        .padding(.all)
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(height: UIScreen.main.bounds.height * 0.7, alignment: .top)
    }

    var products: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            XMStateView(vm.list, reqStatus: vm.reqStatus) { product in
                

                XMDesgin.XMButton {
                    LoadingTask(loadingMessage: "连接苹果商店...") {
                        if let p = iapmanager.products.first(where: { $0.productIdentifier == product.id }) {
                            iapmanager.purchase(product: p)
                        } else {
                            Apphelper.shared.pushNotification(type: .error(message: "没有相关产品。"))
                        }
                    }
                } label: {
                    self.productCell(product)
                }
            } loadingView: {
                ProgressView()
            } emptyView: {
                EmptyView()
            }
        }
    }
    
    func productCell(_ product : XMProduct) -> some View {
        
        VStack(alignment: .center, spacing: 0, content: {
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
    }
}

#Preview {
    CoinshopView()
}
