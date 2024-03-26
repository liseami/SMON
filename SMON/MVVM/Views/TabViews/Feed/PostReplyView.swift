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
    @StateObject var vm: PostReplayViewModel
    init(reply: XMPostReply) {
        self.reply = reply
        self._vm = StateObject(wrappedValue: .init(reply: reply))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            HStack(alignment: .center, spacing: 12, content: {
                XMUserAvatar(str: reply.avatar, userId: reply.userId, size: 20)
                Text(reply.nickname)
                XMDesgin.XMAuthorTag()
                    .ifshow(show: reply.isPostsAuthor.bool)
                Group {
                    Text("回复")
                        .fcolor(.XMDesgin.f2)
                    XMUserAvatar(str: reply.toUserAvatar, userId: reply.toUserId, size: 20)
                    Text(reply.toUserNickname)
                    XMDesgin.XMAuthorTag()
                        .ifshow(show: reply.isPostsAuthor.bool)
                }
                .ifshow(show: reply.toUserId != reply.userId)
                Spacer()
            })
            .font(.XMFont.f2)
            .lineLimit(1)
            .fcolor(.XMDesgin.f1)

            Text(reply.content)
                .font(.XMFont.f2)
                .fcolor(.XMDesgin.f1)

            HStack(alignment: .center, spacing: 12, content: {
                Text(reply.createdAtStr)
                    .font(.XMFont.f3)
                    .fcolor(.XMDesgin.f2)
                Spacer()
                XMLikeBtn(target: PostsOperationAPI.tapCommentLike(commentId: self.vm.reply.id), isLiked: self.vm.reply.isLiked.bool, likeNumbers: self.vm.reply.likeNum,contentId: vm.reply.id) 
            })

        })
    }
}

#Preview {
    PostReplayView(reply: .init())
}
