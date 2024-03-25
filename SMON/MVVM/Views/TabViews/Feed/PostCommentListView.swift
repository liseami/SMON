//
//  PostCommentListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.

import SwiftUI
class PostCommentListViewModel: XMListViewModel<XMPostComment> {
    init(postId: String) {
        super.init(target: PostsOperationAPI.commentList(page: 1, postId: postId))
        Task { await self.getListData() }
    }
}

struct PostCommentListView: View {
    @StateObject var vm: PostCommentListViewModel
    @EnvironmentObject var detailVM: PostDetailViewModel

    @FocusState.Binding var focused: Bool
    
    init(postId: String, focused: FocusState<Bool>.Binding) {
        self._focused = focused
        self._vm = StateObject(wrappedValue: .init(postId: postId))
    }

    var body: some View {
        XMStateView(vm.list,
                    reqStatus: vm.reqStatus,
                    loadmoreStatus: vm.loadingMoreStatus) { comment in
            PostCommentView(comment: comment)
                .onTapGesture {
                    focused = true
                    detailVM.targetComment = comment
                }

        } loadingView: {
            ProgressView()
        } emptyView: {
            Text("--- 暂无评论 ---")
                .font(.XMFont.f2)
                .fcolor(.XMDesgin.f2)
                .padding(.vertical, 32)
        }
        .onChange(of: detailVM.mod == nil) { _ in
            Task { await vm.getListData() }
        }
    }
}

#Preview {
//    PostCommentListView(postId: "", input: <#FocusState<Bool>.Binding#>, input: )
//        .environmentObject(PostDetailViewModel(postId: ""))
    EmptyView()
}
