//
//  FeedListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI

class PostListViewModel: XMListViewModel<XMPost> {
    override init(target: XMTargetType, pagesize: Int = 20, atKeyPath: String = .datalist) {
        super.init(target: target, pagesize: 20)
        Task {
            await self.getListData()
        }
    }
}

struct PostListView: View {
    @StateObject var vm: PostListViewModel
    init(target: XMTargetType) {
        self._vm = StateObject(wrappedValue: .init(target: target))
    }

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus) { post in
                    PostView(post)
                } loadingView: {
                    ProgressView()
                } emptyView: {
                    XMEmptyView()
                }

            })
            .padding(.all, 16)
        }
        .refreshable {}
    }
}

#Preview {
    PostListView(target: PostAPI.followList(page: 1))
}
