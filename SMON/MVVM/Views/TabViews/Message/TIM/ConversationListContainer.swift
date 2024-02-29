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
    func makeUIViewController(context: Context) -> UIViewController {
        let conListController = TUIConversationListController()
        conListController.delegate = context.coordinator
        conListController.navigationItem.title = "消息"
        return conListController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
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
            let data = TUIChatConversationModel()
            data.userID = conversation.userID
            conversationController.navigationController?.pushViewController(ChatView(conversation: data).host(), animated: true)
        }
    }
}
