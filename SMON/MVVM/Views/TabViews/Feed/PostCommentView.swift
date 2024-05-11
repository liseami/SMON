//
//  PostCommentView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/25.
//

import SwiftUI

class PostCommentViewModel: XMListViewModel<XMPostReply> {
    var comment: XMPostComment
    init(comment: XMPostComment) {
        self.comment = comment
        super.init(target: PostsOperationAPI.commentReplyList(page: 1, commentId: comment.id))
    }
}

struct PostCommentView: View {
    var comment: XMPostComment
    @StateObject var vm: PostCommentViewModel
    @FocusState.Binding var focused: Bool
    @EnvironmentObject var superVm: PostDetailViewModel
    init(comment: XMPostComment, focused: FocusState<Bool>.Binding) {
        self._focused = focused
        self.comment = comment
        self._vm = StateObject(wrappedValue: .init(comment: comment))
    }

    var replyList: [XMPostReply] {
        let replayDict = Dictionary(grouping: vm.list, by: \.id)
        let uniqueReplays = replayDict.values.flatMap { $0 }
        return uniqueReplays
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            XMUserAvatar(str: comment.avatar, userId: comment.userId, size: 38)
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name.ADD_NEW_REPLEY_SUCCESS)) { obj in
                    if let newReply = obj.object as? XMPostReply,
                       superVm.commentTargetInfo?.id == comment.id
                    {
                        vm.list.insert(newReply, at: 0)
                    }
                }
            VStack(alignment: .leading, spacing: 8, content: {
                // 主回复
                let mainpost = VStack(alignment: .leading, spacing: 8, content: {
                    HStack(alignment: .center, spacing: 12, content: {
                        Text(comment.nickname)
                            .font(.XMFont.f2b)
                            .lineLimit(1)
                            .fcolor(.XMColor.f1)
                        XMDesgin.XMAuthorTag()
                            .ifshow(show: comment.isPostsAuthor.bool)
                        Spacer()
                        XMLikeBtn(target: PostsOperationAPI.tapCommentLike(commentId: self.vm.comment.id), isLiked: self.vm.comment.isLiked.bool, likeNumbers: self.vm.comment.likeNum, contentId: self.vm.comment.id)
                    })
                    Text(comment.content)
                        .font(.XMFont.f2)
                        .fcolor(.XMColor.f1)
                    Text(comment.createdAtStr)
                        .font(.XMFont.f3)
                        .fcolor(.XMColor.f2)
                })
                .contentShape(Rectangle())

                mainpost.onTapGesture {
                    superVm.commentTargetInfo = comment
                    focused = true
                }

                let list = ForEach(vm.list, id: \.id) { replay in
                    // 回复的回复列表
                    PostReplayView(reply: replay, comment: comment)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            superVm.commentTargetInfo = .init(id: self.comment.id, userId: replay.userId, nickname: replay.nickname, avatar: replay.avatar, isLiked: replay.isLiked, isPostsAuthor: replay.isPostsAuthor, likeNum: replay.likeNum, commentNum: 0, content: replay.content, imagePath: replay.imagePath, createdAt: replay.createdAt.int ?? 0, createdAtStr: replay.createdAtStr)
                            focused = true
                        }
                }

                list
                    .contentShape(Rectangle())

                XMDesgin.XMButton {
                    await vm.getListData()
                } label: {
                    Text("展开\((comment.commentNum ?? 0) - vm.list.count)条回复")
                        .font(.XMFont.f2).bold()
                        .fcolor(.XMColor.f2)
                        .ifshow(show: (comment.commentNum ?? 0) - vm.list.count > 0)
                }

            })
        }
    }
}

#Preview {
    Color.red
//    PostCommentView(comment: .init(id: "3223", userId: "3243", nickname: "djjaj", avatar: "dajj", isLiked: 1, isPostsAuthor: 1, likeNum: 223, commentNum: 212, content: "dsfjsdfjajsdfja", imagePath: "dkfa", createdAt: 123131, createdAtStr: "dfsjdfj"), focused: <#FocusState<Bool>.Binding#>)
//        .environmentObject(PostDetailViewModel.init(postId: "32"))
}
