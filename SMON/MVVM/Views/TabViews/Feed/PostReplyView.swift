//
//  PostReplyView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/25.
//

import SwiftUI

class PostReplayViewModel: ObservableObject {
    var reply: XMPostReply
    init(reply: XMPostReply) {
        self.reply = reply
    }
}

struct PostReplayView: View {
    var reply: XMPostReply
    var comment: XMPostComment
    @EnvironmentObject var superVm: PostDetailViewModel
    @StateObject var vm: PostReplayViewModel
    init(reply: XMPostReply, comment: XMPostComment) {
        self.reply = reply
        self._vm = StateObject(wrappedValue: .init(reply: reply))
        self.comment = comment
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            HStack(alignment: .center, spacing: 12, content: {
                HStack(alignment: .center, spacing: 4) {
                    XMUserAvatar(str: reply.avatar, userId: reply.userId, size: 20)
                    Text(reply.nickname)
                    XMDesgin.XMAuthorTag()
                        .ifshow(show: reply.isPostsAuthor.bool)
                }
                Group {
                    Text("回复")
                        .fcolor(.XMColor.f2)
                    HStack(alignment: .center, spacing: 4) {
                        XMUserAvatar(str: reply.toUserAvatar, userId: reply.toUserId, size: 20)
                        Text(reply.toUserNickname)
                        XMDesgin.XMAuthorTag()
                            .ifshow(show: reply.isPostsAuthor.bool)
                    }
                }
                .ifshow(show: reply.toUserId != comment.userId)
                Spacer()
                XMLikeBtn(target: PostsOperationAPI.tapCommentLike(commentId: self.vm.reply.id), isLiked: self.vm.reply.isLiked.bool, likeNumbers: self.vm.reply.likeNum, contentId: vm.reply.id)
            })
            .font(.XMFont.f2)
            .lineLimit(1)
            .fcolor(.XMColor.f1)
            Text(reply.content)
                .font(.XMFont.f2)
                .fcolor(.XMColor.f1)
            Text(reply.createdAtStr)
                .font(.XMFont.f3)
                .fcolor(.XMColor.f2)
        })
    }
}

#Preview {
    PostReplayView(reply: .init(), comment: .init())
        .environmentObject(PostDetailViewModel(postId: ""))
}
