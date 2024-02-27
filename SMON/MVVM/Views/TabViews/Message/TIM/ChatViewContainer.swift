//import SwiftUI
//
//struct ChatViewContainer: UIViewControllerRepresentable {
//    let conversation: BIMConversation
//    
//    init(conversation: BIMConversation) {
//        self.conversation = conversation
//    }
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let chatVC = BIMChatViewController.chatVC(with: self.conversation)
//        chatVC.overrideUserInterfaceStyle = .light
//        chatVC.delegate = context.coordinator
//        return chatVC
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, BIMChatViewControllerDelegate {
//        func chatViewController(_ controller: BIMChatViewController!, didClickAvatar message: BIMMessage!) {
//            guard let navi = Apphelper.shared.findGlobalNavigationController() else { return }
//            navi.pushViewController(ProfileView().host(), animated: true)
//        }
//        
//        var parent: ChatViewContainer
//        
//        init(_ parent: ChatViewContainer) {
//            self.parent = parent
//        }
//    }
//}
