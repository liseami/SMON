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
        HStack(alignment: .top, spacing: 12) {
            XMUserAvatar(str: reply.avatar, userId: reply.userId, size: 38)
            VStack(alignment: .leading, spacing: 8, content: {
                HStack(alignment: .center, spacing: 12, content: {
                    Text(reply.nickname)
                        .font(.XMFont.f2b)
                        .lineLimit(1)
                        .fcolor(.XMDesgin.f1)
                    Spacer()
                })

                Text(reply.content)
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f1)

                HStack(alignment: .center, spacing: 12, content: {
                    Text(reply.createdAtStr)
                        .font(.XMFont.f3)
                        .fcolor(.XMDesgin.f2)
                    Spacer()
                    HStack {
                        XMDesgin.XMIcon(iconName: "feed_heart", size: 16, withBackCricle: true)
                        Text(reply.likeNum.string)
                            .font(.XMFont.f3)
                            .bold()
                    }
                    XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
                })

            })
        }
    }
}

#Preview {
    PostReplayView(reply: .init())
}
