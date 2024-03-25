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
                    HStack {
                        XMDesgin.XMIcon(iconName: "feed_heart", size: 16, withBackCricle: true)
                        Text(comment.likeNum.string)
                            .font(.XMFont.f3)
                            .bold()
                    }
                    XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
                })

                ForEach(vm.list, id: \.id) { replay in
                    PostReplayView(reply: replay)
                }

                XMDesgin.XMButton {
                    vm.currentPage = 0
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
