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
    @EnvironmentObject var vm: ProfileViewModel
    let gifts: [XMGift] = [
        .init(image: "xm_gift_1", price: 1, count: 5, discountRate: 0),
        .init(image: "xm_gift_2", price: 12, count: 60, discountRate: 25),
        .init(image: "xm_gift_3", price: 30, count: 170, discountRate: 22),
        .init(image: "xm_gift_4", price: 98, count: 520, discountRate: 33),
        .init(image: "xm_gift_5", price: 368, count: 2450, discountRate: 34),
        .init(image: "xm_gift_6", price: 798, count: 5200, discountRate: 35),
        .init(image: "xm_gift_7", price: 798, count: 6666, discountRate: 36),
        .init(image: "xm_gift_8", price: 798, count: 9999, discountRate: 37),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24, content: {
            HStack(spacing: 16) {
                XMUserAvatar(str: vm.user.avatar, userId: vm.userId, size: 80)
                VStack(alignment: .leading, spacing: 6) {
                    // 昵称
                    Text(vm.user.nickname)
                        .font(.XMFont.f1b)
                    // 星座等信息
                    Text("\(vm.user.zodiac) · \(vm.user.bdsmAttr.bdsmAttrString) · \(vm.user.emotionalNeeds.emotionalNeedsString)")
                        .fixedSize(horizontal: true, vertical: false)
                        .fcolor(.XMDesgin.f2)
                        .font(.XMFont.f2b)
                }
                Spacer()
            }
            // 微信号掩码
            progressLine
            HStack {
                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .green, iconName: "inforequest_wechat", text: vm.user.wechat) {}
                XMDesgin.XMTag(text: "好评率 100%")
            }
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 8) {
                    ForEach(self.gifts, id: \.self.count) { gift in
                        let gift = VStack(alignment: .center, spacing: 0, content: {
                            VStack(alignment: .center, spacing: 12, content: {
                                Image(gift.image)
                                    .resizable()
                                    .frame(width: 56, height: 56, alignment: .center)
                                Text("热情玫瑰")
                                    .font(.XMFont.f3)
                            })
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            Text("\(gift.price) 赛币")
                                .font(.XMFont.f3)
                                .fcolor(Color.pink)
                                .padding(.vertical, 6)
                        })
                        .background(RoundedRectangle(cornerRadius: 12)
                            .fill(Color.XMDesgin.b1.gradient.shadow(.drop(color: Color.pink, radius: 0))))
                        XMDesgin.XMButton {
                            LoadingTask(loadingMessage: "连接苹果商店...") {}
                        } label: {
                            gift
                        }
                    }
                }
                .padding(.all, 2)
            })
        })
        .padding(.top, 16)
        .padding(.all, 16)
    }

    var progressLine: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            ZStack(alignment: .leading) {
                Capsule().fill(Color.XMDesgin.b3.opacity(0.3).gradient)
                Capsule().fill(Color.green.gradient)
                    .frame(width: 40 + CGFloat(240 * 4 / 23))
            }
            .frame(height: 5)
            Text("* 因对方设置，距离解锁微信还需3020赛币。")
                .font(.XMFont.f2)
                .fcolor(.XMDesgin.f2)
            Text("* 系统已助力320赛币。")
                .font(.XMFont.f2)
                .fcolor(.XMDesgin.f2)
        })
    }
}

#Preview {
    NavigationView(content: {
        Text("")
            .onAppear(perform: {
                Apphelper.shared.presentPanSheet(WechatGiftView()
                    .environmentObject(ProfileViewModel(userId: "1765668637701701633")), style: .shop)
            })
    })
}
