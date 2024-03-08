//
//  WechatGiftView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import SwiftUI

struct XMGift {
    var image: String
    var price: Int
    var count: Int
    var discountRate: Int
}

struct WechatGiftView: View {
    let gifts: [XMGift] = [
        .init(image: "saicoin_lvl1", price: 1, count: 5, discountRate: 0),
        .init(image: "saicoin_lvl2", price: 12, count: 60, discountRate: 25),
        .init(image: "saicoin_lvl3", price: 30, count: 170, discountRate: 22),
        .init(image: "saicoin_lvl4", price: 98, count: 590, discountRate: 33),
        .init(image: "saicoin_lvl5", price: 368, count: 2450, discountRate: 34),
        .init(image: "saicoin_lvl6", price: 798, count: 5400, discountRate: 35),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24, content: {
            HStack(spacing: 16) {
                WebImage(str: AppConfig.mokImage!.absoluteString)
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 6) {
                    Text("小狐狸")
                        .font(.XMFont.f1b)
                    Text("天蝎座 · S · 长期关系")
                        .fcolor(.XMDesgin.f2)
                        .font(.XMFont.f2b)
                }
                Spacer()
                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .green, iconName: "inforequest_wechat", text: "dl****ie") {}
                    
            }
            progressLine
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 16) {
                    ForEach(self.gifts, id: \.self.count) { gift in
                        let gift = VStack(alignment: .center, spacing: 0, content: {
                            VStack(alignment: .center, spacing: 12, content: {
                                Image(gift.image)
                                    .resizable()
                                    .frame(width: 32, height: 32, alignment: .center)
                                Text("热情玫瑰")
                                    .font(.XMFont.f3b)
                            })
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            Text("¥\(gift.price) 赛币")
                                .font(.XMFont.f3b)
                                .fcolor(Color.green)
                                .padding(.vertical, 6)
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.all, 3)
                        XMDesgin.XMButton {
                            LoadingTask(loadingMessage: "连接苹果商店...") {}
                        } label: {
                            gift
                        }
                    }
                }
            })
        })
        .padding(.all, 16)
    }

    var progressLine: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            ZStack(alignment: .leading) {
                Capsule().fill(Color.XMDesgin.b3.opacity(0.3))
                LinearGradient(gradient: Gradient(colors: [Color(hex: "AA7E1F"), Color(hex: "7A5309"), Color(hex: "AA7E1F")]), startPoint: .leading, endPoint: .trailing)
                    .clipShape(Capsule())
                    .frame(width: 40 + CGFloat(240 * 4 / 23))
            }
            .frame(height: 5)
            Text("因对方设置，距离解锁微信还需3020钻")
                .font(.XMFont.f2)
                .fcolor(.XMDesgin.f2)
        })
    }
}

#Preview {
    WechatGiftView()
}
