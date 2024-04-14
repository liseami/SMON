//
//  ChatView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/26.
//

import SwiftUI
import TUIChat

struct ChatView: View {
    let userId: String
    let conversation: TUIChatConversationModel

    init(userId: String) {
        self.userId = userId
        self.conversation = TUIChatConversationModel()
        self.conversation.userID = userId
    }

    var XMUserId: String {
        var realId = self.userId
        realId.removeFirst()
        return realId
    }

    var body: some View {
        ChatViewContainer(conversation: conversation)
            .edgesIgnoringSafeArea(.bottom)
            .ignoresSafeArea(.keyboard)
            .navigationTitle("用户名")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    XMDesgin.XMButton {
                        Apphelper.shared.pushActionSheet(title: "操作", message: nil, actions: actions)
                    } label: {
                        XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
                    }
                }
            }
    }

    var actions: [UIAlertAction] {
        var result: [UIAlertAction] = [
        ]
        result = [
            UIAlertAction(title: "查看用户主页", style: .default, handler: { _ in
                MainViewModel.shared.pushTo(MainViewModel.PagePath.profile(userId: XMUserId))
            }),
            UIAlertAction(title: "举报用户", style: .default, handler: { _ in
                Task {
                    await Apphelper.shared.report(type: .user, reportValue: XMUserId)
                }
            }),
            UIAlertAction(title: "拉黑用户 / 不再看他", style: .destructive, handler: { _ in
                /*
                 拉黑用户
                 */
                Apphelper.shared.blackUser(userid: self.XMUserId)
            }),
        ]
        return result
    }
}

#Preview {
    NavigationView(content: {
//        ChatView(conversation: BIMConversation())
    })
}
