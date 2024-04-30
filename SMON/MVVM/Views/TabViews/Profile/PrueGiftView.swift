//
//  PrueGiftView.swift

import SwiftUI

class PrueGiftViewModel: XMListViewModel<XMGift> {
    init() {
        super.init(target: GiftAPI.giftList(page: 1, sceneId: "1"))
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

struct PrueGiftView: View {
    @StateObject var vm: PrueGiftViewModel = .init()
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

            XMTyperText(text: "赠送礼物将为对方带来礼物价值 X 10倍的热度！")
                .font(.XMFont.f1)
                .fcolor(.XMDesgin.f1)

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
}

#Preview {
    NavigationView(content: {
        Text("")
            .onAppear(perform: {
                Apphelper.shared.presentPanSheet(PrueGiftView()
                    .environmentObject(ProfileViewModel(userId: "1765668637701701633")), style: .shop)
            })
    })
}
