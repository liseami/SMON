import SwiftUI
import TUIChat

struct ChatViewContainer: UIViewControllerRepresentable {
    let conversation: TUIChatConversationModel
    
    func makeUIViewController(context: Context) -> TUIC2CChatViewController {
        let chatVC = TUIC2CChatViewController()
        chatVC.conversationData = conversation
        
        return chatVC
    }
    
    func updateUIViewController(_ uiViewController: TUIC2CChatViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ChatViewContainer
        
        init(_ parent: ChatViewContainer) {
            self.parent = parent
        }
    }
}
