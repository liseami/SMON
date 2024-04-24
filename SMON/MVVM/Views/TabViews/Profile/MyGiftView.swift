//
//  MyBill.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/24.
//

import SwiftUI

struct XMGiftRecord: Identifiable, Convertible {
    var id: String = "" // : 1782595455415353344,
    var consumeUserId: String = "" // ": 1764504995815882752,
    var nickname: String = "" // ": "开手机",
    var avatar: String = "" // ":" jpg",
    var giftTitle: String = "" // ": "心动礼盒",
    var totalPrice: String = "" // ": 1,
    var createdAtStr: String = "" // ": "10:20"
}

class MyGiftViewModel: XMListViewModel<XMGiftRecord> {
    init() {
        super.init(target: GiftAPI.giftsReceivedList(page: 1))
        Task { await self.getListData() }
    }
}

struct MyGiftView: View {
    @StateObject var vm: MyGiftViewModel = .init()
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 12, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 1) { gift in
                    HStack {
                        VStack(alignment: .leading, spacing: 12, content: {
                            HStack(alignment: .center, spacing: 12, content: {
                                XMUserAvatar(str: gift.avatar, userId: gift.consumeUserId, size: 32)
                                Text(gift.nickname)
                                    .font(.XMFont.f1b)
                            })
                            Text(gift.giftTitle)
                                .font(.XMFont.f1b)
                            Text(gift.createdAtStr)
                                .font(.XMFont.f3)
                        })
                        Spacer()
                        Text("x" + gift.totalPrice)
                            .font(.XMFont.big3.bold())
                    }
                    .padding(.all, 12)
                    .background(Color.XMDesgin.b1)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } loadingView: {
                    ProgressView()
                } emptyView: {
                    XMEmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }

            })
            .padding(.all)
        }
        .navigationTitle("我收到的礼物")
    }
}

#Preview {
    MyGiftView()
}
