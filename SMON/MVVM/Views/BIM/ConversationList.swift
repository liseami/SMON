//
//  BIMConversationListController.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/24.
//
import SwiftUI

struct ConversationListContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        let conListController = BIMConversationListController()
        conListController.delegate = context.coordinator
        
        viewController.addChild(conListController)
        viewController.view.addSubview(conListController.view)
        
        return viewController
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
        
        func conversationListController(_ controller: BIMConversationListController?, didSelectConversation conversation: BIMConversation?) {
            // Handle conversation selection
            // You can pass the selected conversation to SwiftUI or perform any other actions here
        }

        func conversationListController(_ controller: BIMBaseConversationListController?, didSelect conversation: BIMConversation?) {}
        
        func conversationListController(_ controller: BIMBaseConversationListController?, onTotalUnreadMessageCountChanged totalUnreadCount: UInt) {}
    }
}
