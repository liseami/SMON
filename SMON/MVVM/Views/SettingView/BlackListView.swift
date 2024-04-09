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
                    XMUserLine(user: user)
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
