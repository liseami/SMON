import SwiftUI
import TUIChat

struct ChatViewContainer: UIViewControllerRepresentable {
    let conversation: TUIChatConversationModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        let chatVC = TUIC2CChatViewController()
        chatVC.conversationData = conversation
        return chatVC
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
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
