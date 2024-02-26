//
//  BIMConversationListController.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/24.
//
import SwiftUI


struct ConversationListContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let conListController = BIMConversationListController()
        conListController.delegate = context.coordinator
        return conListController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, BIMConversationListControllerDelegate {
        var parent: ConversationListContainer
        
        init(_ parent: ConversationListContainer) {
            self.parent = parent
        }
        
        // 点击会话
        func conversationListController(_ controller: BIMBaseConversationListController?, didSelect conversation: BIMConversation?) {
            guard let conversation else { return }
            guard let globalNavigationController = Apphelper.shared.findGlobalNavigationController() else { return }
            globalNavigationController.pushViewController(UIHostingController(rootView: ChatView(conversation: conversation)), animated: true)
        }
        
        // 全部未读数改变
        func conversationListController(_ controller: BIMBaseConversationListController?, onTotalUnreadMessageCountChanged totalUnreadCount: UInt) {}
    }
}
