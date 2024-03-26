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
    init(comment: XMPostComment) {
        self.comment = comment
        self._vm = StateObject(wrappedValue: .init(comment: comment))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            XMUserAvatar(str: comment.avatar, userId: comment.userId, size: 38)
            VStack(alignment: .leading, spacing: 8, content: {
                HStack(alignment: .center, spacing: 12, content: {
                    Text(comment.nickname)
                        .font(.XMFont.f2b)
                        .lineLimit(1)
                        .fcolor(.XMDesgin.f1)
                    XMDesgin.XMAuthorTag()
                        .ifshow(show: comment.isPostsAuthor.bool)
                    Spacer()
                })

                Text(comment.content)
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f1)

                HStack(alignment: .center, spacing: 12, content: {
                    Text(comment.createdAtStr)
                        .font(.XMFont.f3)
                        .fcolor(.XMDesgin.f2)
                    Spacer()
                    XMLikeBtn(target: PostsOperationAPI.tapCommentLike(commentId: self.vm.comment.id), isLiked: self.vm.comment.isLiked.bool, likeNumbers: self.vm.comment.likeNum,contentId: self.vm.comment.id)
                })

                let replayDict = Dictionary(grouping: vm.list, by: \.id)
                let uniqueReplays = replayDict.values.flatMap { $0 }
                let list = ForEach(uniqueReplays, id: \.id) { replay in
                    PostReplayView(reply: replay)
                }
                list
                    .contentShape(Rectangle())

                XMDesgin.XMButton {
                    await vm.loadMore()
                } label: {
                    Text("展开\(comment.commentNum - vm.list.count)条回复")
                        .font(.XMFont.f2).bold()
                        .fcolor(.XMDesgin.f2)
                        .ifshow(show: comment.commentNum - vm.list.count > 0)
                }

            })
        }
        
    }
}

#Preview {
    PostCommentView(comment: .init())
}
