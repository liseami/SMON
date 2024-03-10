//
//  CoinshopView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI
import SwiftUIX
struct XMProduct {
    var image: String
    var price: Int
    var count: Int
    var discountRate: Int
}

class StoreManager: ObservableObject {
    let products: [XMProduct] = [
        .init(image: "saicoin_lvl1", price: 1, count: 5, discountRate: 0),
        .init(image: "saicoin_lvl2", price: 12, count: 60, discountRate: 25),
        .init(image: "saicoin_lvl3", price: 30, count: 170, discountRate: 22),
        .init(image: "saicoin_lvl4", price: 98, count: 590, discountRate: 33),
        .init(image: "saicoin_lvl5", price: 368, count: 2450, discountRate: 34),
        .init(image: "saicoin_lvl6", price: 798, count: 5400, discountRate: 35),
    ]
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
                    Text("0 赛币(余额)")
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
//        .background(Color.red)
    }

    var products: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            ForEach(vm.products, id: \.self.count) { product in
                let product = VStack(alignment: .center, spacing: 0, content: {
                    VStack(alignment: .center, spacing: 12, content: {
                        Image(product.image)
                            .resizable()
                            .frame(width: 56, height: 56, alignment: .center)
                        Text("\(product.count)赛币")
                            .font(.XMFont.big3.bold())
                    })
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.black)
                    VStack(alignment: .center, spacing: 3, content: {
                        Text("¥\(product.price).00")
                            .font(.XMFont.f1b)
                            .fcolor(Color.green)
                        Text("\(product.discountRate)%")
                            .font(.XMFont.f3b)
                            .fcolor(.XMDesgin.f2)
                            .opacity(product.discountRate == 0 ? 0 : 1)
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
                    LoadingTask(loadingMessage: "连接苹果商店...") {}
                } label: {
                    product
                }
            }
        }
    }
}

#Preview {
    CoinshopView()
}
