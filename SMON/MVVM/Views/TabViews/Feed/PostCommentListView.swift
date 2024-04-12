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

    @MainActor
    func delete(commentId: String) async {
        let t = PostsOperationAPI.commentDelete(commentId: commentId)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            self.list.removeAll(where: { $0.id == commentId })
        }
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
            let commentView = PostCommentView(comment: comment)
                .contentShape(Rectangle())
                .onTapGesture {
                    focused = true
                    detailVM.targetComment = comment
                }

            // 自己的评论可以删除
            if comment.userId == UserManager.shared.user.userId {
                commentView.onLongPressGesture(minimumDuration: 0.5, maximumDistance: 1) {
                    Apphelper.shared.pushActionSheet(title: "操作", message: "", actions: [UIAlertAction(title: "删除", style: .destructive, handler: { _ in
                        Task { await vm.delete(commentId: comment.id) }
                    })])
                }
            } else {
                commentView
            }

        } loadingView: {
            ProgressView()
        } emptyView: {
            Text("--- 暂无评论 ---")
                .font(.XMFont.f2)
                .fcolor(.XMDesgin.f2)
                .padding(.vertical, 32)
        }
        .onChange(of: detailVM.mod.id) { _ in
            Task { await vm.getListData() }
        }
    }
}

#Preview {
//    PostCommentListView(postId: "", input: <#FocusState<Bool>.Binding#>, input: )
//        .environmentObject(PostDetailViewModel(postId: ""))
    EmptyView()
}
