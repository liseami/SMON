//
//  LoginMainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import AVKit
import SwiftUI
struct LoginMainView: View {
    @StateObject var vm: LoginViewModel = .init()
    let player = AVPlayer(url: Bundle.main.url(forResource: "hello", withExtension: "mp4")!)
    var body: some View {
        NavigationView(content: {
            ZStack(content: {
                // Use a GeometryReader to get the size of the screen

                switch vm.pageProgress {
                case .AppFeatures:
                    ZStack {
                        VideoPlayer(player: player) {
                            Color.black.opacity(0.3).ignoresSafeArea()
                        }
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .onAppear {
                            self.player.play()
                            // Set up observer for end of playback
                            NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: self.player.currentItem,
                                queue: nil)
                            { _ in
                                // Seek back to the beginning
                                self.player.seek(to: .zero)
                                // Start playing again
                                self.player.play()
                            }
                        }
                        AppFeaturesView()
                    }

                case .Warning:
                    AppWarningView()
                case .Login:
                    LoginView_PhoneNumber()
                }
            })

        })
        .environmentObject(vm)
    }
}

#Preview {
    LoginMainView()
}
