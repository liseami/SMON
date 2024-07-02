//
//  BIMConversationListController.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/24.
//
import SwiftUI
import TUIChat
import TUIConversation

struct ConversationListContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TUIConversationListController {
        let conListController = TUIConversationListController()
        conListController.delegate = context.coordinator
        conListController.navigationItem.title = "消息"
        
        
        
        return conListController
    }

    func updateUIViewController(_ uiViewController: TUIConversationListController, context: Context) {
        // Update the view controller if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, TUIConversationListControllerListener {
        var parent: ConversationListContainer

        init(_ parent: ConversationListContainer) {
            self.parent = parent
        }

        func conversationListController(_ conversationController: UIViewController, didSelectConversation conversation: TUIConversationCellData) {
            /*
             清理未读数
             */
            V2TIMManager.sharedInstance().cleanConversationUnreadMessageCount(conversation.conversationID, cleanTimestamp: UInt64(Date.now.timeIntervalSince1970), cleanSequence: UInt64(0)) {} fail: { _, _ in
            }
            if conversation.userID == "m1001" {
                MainViewModel.shared.pushTo(MainViewModel.PagePath.notification)
            } else {
                MainViewModel.shared.pushTo(MainViewModel.PagePath.chat(userId: conversation.userID))
            }
        }
    }
}
