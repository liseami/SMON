//
//  WechatGiftView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import SwiftUI

struct XMGift: Convertible, Identifiable {
    var id: String = "" // : 1,
    var title: String = "" // ": "心动礼盒",
    var coverUrl: String = "" // ": "httapp/gifts/goods1.png",
    var mediaUrl: String = "" // ": "",
    var payFee: String = "" // ": 1
}

class WechatGiftViewModel: XMListViewModel<XMGift> {
    init() {
        super.init(target: GiftAPI.giftList(page: 1,sceneId: "1"))
        Task { await self.getListData() }
    }

    /*
     送礼物
     */
    @MainActor
    func sendGift(giftId: String, userid: String) async {
        let t = GiftAPI.gift(p: .init(incomeUserId: userid, sceneId: "1", sceneValue: userid, giftId: giftId, giftNum: "1"))
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            Apphelper.shared.pushNotification(type: .success(message: "赠送成功！💗"))
        }
    }
}

struct WechatGiftView: View {
    @StateObject var vm: WechatGiftViewModel = .init()
    @EnvironmentObject var superVm: ProfileViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24, content: {
            HStack(spacing: 16) {
                XMUserAvatar(str: superVm.user.avatar, userId: superVm.userId, size: 80)
                VStack(alignment: .leading, spacing: 6) {
                    // 昵称
                    Text(superVm.user.nickname)
                        .font(.XMFont.f1b)
                    // 星座等信息
                    Text("\(superVm.user.zodiac) · \(superVm.user.bdsmAttr.bdsmAttrString) · \(superVm.user.emotionalNeeds.emotionalNeedsString)")
                        .fixedSize(horizontal: true, vertical: false)
                        .fcolor(.XMDesgin.f2)
                        .font(.XMFont.f2b)
                }
                Spacer()
            }
            // 微信号掩码
            progressLine
            HStack {
                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .green, iconName: "inforequest_wechat", text: superVm.user.wechat) {}
//                XMDesgin.XMTag(text: "好评率 100%")
            }
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 8) {
                    ForEach(vm.list, id: \.id) { gift in

                        XMDesgin.XMButton {
                            await vm.sendGift(giftId: gift.id, userid: superVm.userId)
                        } label: {
                            VStack(alignment: .center, spacing: 0, content: {
                                VStack(alignment: .center, spacing: 12, content: {
                                    WebImage(str: gift.coverUrl)
                                        .frame(width: 56, height: 56, alignment: .center)
                                    Text(gift.title)
                                        .font(.XMFont.f3)
                                })
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                Text("\(gift.payFee) 赛币")
                                    .font(.XMFont.f3)
                                    .fcolor(Color.pink)
                                    .padding(.vertical, 6)
                            })
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(Color.XMDesgin.b1.gradient.shadow(.drop(color: Color.pink, radius: 0))))
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
