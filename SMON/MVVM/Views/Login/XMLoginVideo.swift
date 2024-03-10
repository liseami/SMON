//
//  XMLoginVideo.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/10.
//

import AVKit
import SwiftUI



#Preview {
    XMLoginVideo()
}

struct XMLoginVideo: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let playerView = PlayerView()
        playerView.player = AVPlayer(url: Bundle.main.url(forResource: "LoginBackgroundVideo", withExtension: "mp4")!)
        
        playerView.player?.play()
        
        return playerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // 无需执行任何操作,因为视频播放器是独立的
    }
}

class PlayerView: UIView {
    var player: AVPlayer? {
        didSet {
            if let player = player {
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = UIScreen.main.bounds
                playerLayer.videoGravity = .resizeAspectFill
                layer.addSublayer(playerLayer)

                player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/60.0, preferredTimescale: 60), queue: nil) { time in
                    player.play()
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let playerLayer = layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = UIScreen.main.bounds
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 让整个视图区域都可以响应事件
        return bounds.contains(point)
    }
}
