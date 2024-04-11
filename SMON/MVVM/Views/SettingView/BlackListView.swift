//
//  BlackListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/10.
//

import SwiftUI

class BlackListViewModel: XMListViewModel<XMUserProfile> {
    init() {
        super.init(target: UserRelationAPI.blackList(page: 1), pagesize: 20)
        Task { await self.getListData() }
    }
}

struct BlackListView: View {
    @StateObject var vm: BlackListViewModel = .init()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { user in
                    HStack(alignment: .top, spacing: 12) {
                        XMUserAvatar(str: user.avatar, userId: user.userId, size: 44)
                        HStack {
                            Text(user.nickname)
                                .font(.XMFont.f1b)
                            Spacer()
                            XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "解除黑名单") {
                                Task {
                                    let t = UserRelationAPI.tapBlack(blackUserId: user.userId)
                                    let r = await Networking.request_async(t)
                                    if r.is2000Ok {
                                        self.vm.list.removeAll(where: { $0.userId == user.userId })
                                    }
                                }
                            }
                        }
                    }
                } loadingView: {
                    UserListLoadingView()
                } emptyView: {
                    XMEmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }

            })
            .padding(.all, 16)
        })
        .navigationTitle("黑名单")
    }
}

#Preview {
    BlackListView()
}
