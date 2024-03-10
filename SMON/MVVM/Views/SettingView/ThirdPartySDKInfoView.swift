import SwiftUI

struct ThirdPartySDKInfoView: View {
    @State private var podfileContent = ""

    var body: some View {
        List {
            XMSection(title: "第三方SDK接入") {
                if podfileContent.isEmpty {
                    Text("加载中...")
                } else {
                    ForEach(podfileContent.split(separator: "\n"), id: \.self) { line in
                        Text(line)
                            .font(.system(.body, design: .monospaced))
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .listStyle(.plain)
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
