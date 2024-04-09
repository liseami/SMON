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
                    XMDesgin.XMIcon(iconName: "system_more")
                        .onTapGesture {
                          
                        }
                }
            }
    }
}

#Preview {
    NavigationView(content: {
//        ChatView(conversation: BIMConversation())
    })
}
