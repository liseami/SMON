//
//  ChatView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/26.
//

import SwiftUI
import TUIChat

struct ChatView: View {
    let conversation : TUIChatConversationModel
    var body: some View {
        ChatViewContainer(conversation: conversation)
            .edgesIgnoringSafeArea(.bottom)
            .ignoresSafeArea(.keyboard)
            .navigationTitle("用户名")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    XMDesgin.XMIcon(iconName: "system_more")
                }
            }
    }
}

#Preview {
    NavigationView(content: {
//        ChatView(conversation: BIMConversation())
    })
}
