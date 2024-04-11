import SwiftUI

struct ThirdPartySDKInfoView: View {
    @State private var podfileContent = ""

    var body: some View {
        InAppBrowser(url: AppConfig.UserPrivacyPolicy)
            .preferredColorScheme(.dark)
        .navigationTitle("第三方SDK接入信息")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadPodfileContent()
        }
    }

    private func loadPodfileContent() {
        guard let podfileURL = Bundle.main.url(forResource: "Podfile", withExtension: nil) else {
            return
        }

        do {
            podfileContent = try String(contentsOf: podfileURL)
        } catch {
            print("Error loading Podfile content: \(error)")
        }
    }
}

#Preview {
    ThirdPartySDKInfoView()
}
