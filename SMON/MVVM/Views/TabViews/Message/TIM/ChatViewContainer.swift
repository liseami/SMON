import SwiftUI
import TUIChat
import TUIConversation

struct ChatViewContainer: UIViewControllerRepresentable {
    let conversation: TUIChatConversationModel
    
    func makeUIViewController(context: Context) -> TUIC2CChatViewController {
        let chatVC = TUIC2CChatViewController()
        chatVC.conversationData = conversation
        chatVC.delegate = context.coordinator as! any TUIMessageTapDelegate
        return chatVC
    }
    
    func updateUIViewController(_ uiViewController: TUIC2CChatViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, TUIMessageTapDelegate {
        func tap(_ cell: TUIMessageCell, postId: String) {
            MainViewModel.shared.pushTo(MainViewModel.PagePath.postdetail(postId: postId))
        }
        
               
        var parent: ChatViewContainer
        
        init(_ parent: ChatViewContainer) {
            self.parent = parent
        }
        
        
        
        
    }
}
