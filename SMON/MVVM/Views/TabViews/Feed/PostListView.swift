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
                XMStateView(vm.list,
                            reqStatus: vm.reqStatus,
                            loadmoreStatus: vm.loadingMoreStatus,
                            pagesize: 20) { post in
                    PostView(post)
                } loadingView: {
                    PostListLoadingView()
                } emptyView: {
                    VStack(spacing: 24) {
                        Text("暂无帖子，快快发布吧！")
                            .font(.XMFont.f1)
                            .fcolor(.XMDesgin.f2)
                        LoadingPostView()
                    }
                    .padding(.top, 12)
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }

            })
            .padding(.all, 16)
        }
        .refreshable {
            await vm.getListData()
        }
    }
}

#Preview {
    PostListView(target: PostAPI.followList(page: 1))
}
