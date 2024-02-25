import SwiftUI

struct ChatViewContainer: UIViewControllerRepresentable {
    let conversation: BIMConversation
    
    init(conversation: BIMConversation) {
        self.conversation = conversation
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = ChatContainerViewController()
        viewController.coordinator = context.coordinator
        
        let chatVC = BIMChatViewController.chatVC(with: self.conversation)
        chatVC.overrideUserInterfaceStyle = .dark
        viewController.addChild(chatVC)
        viewController.view.addSubview(chatVC.view)
        viewController.overrideUserInterfaceStyle = .dark
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ChatViewContainer
        
        init(_ parent: ChatViewContainer) {
            self.parent = parent
        }
        
        // Add your viewDidLoad logic here
        func viewDidLoad() {
            // Perform actions when the view is loaded
            print("View loaded")	
        }
    }
}

class ChatContainerViewController: UIViewController {
    var coordinator: ChatViewContainer.Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.viewDidLoad()
    }
}
