//
//  PublicFuncs.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation
import JDStatusBarNotification
import Kingfisher
import Lantern
import PanModal
import SwiftUIX
import UIKit

class Apphelper {
    static let shared: Apphelper = .init()

    /*
     马达
     */
    func mada(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }

    func nofimada(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func getWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
        for scene in connectedScenes {
            if let sceneDelegate = scene.delegate as? UIWindowSceneDelegate {
                if let window = sceneDelegate.window {
                    return window
                }
            }
        }
        return nil
    }

    /*
     全局最高级ViewController
     */
    func topMostViewController() -> UIViewController? {
        let vc = UIApplication.shared.connectedScenes.filter {
            $0.activationState == .foregroundActive
        }.first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .topMostViewController()

        return vc
    }

    /*
     推送系统sheet
     */
    func present<V: View>(_ view: V,
                          named name: AnyHashable? = nil,
                          onDismiss: @escaping () -> Void = {},
                          presentationStyle: ModalPresentationStyle? = nil,
                          completion: @escaping () -> Void = {})
    {
        topMostViewController()?.present(view.environment(\.colorScheme, .dark), named: name, onDismiss: onDismiss, presentationStyle: presentationStyle, completion: completion)
    }

    /*
     推送PanSheet页面
     */
    func presentPanSheet<T: View>(_ view: T, style: PanPresentStyle) {
        topMostViewController()?.presentPanModal(PanViewBox(content: view, style: style))
    }


    enum NotificationType {
        case success(message: String)
        case info(message: String)
        case warning(message: String)
        case error(message: String)
        case loading(message: String)
    }

    /*
     弹出小提示
     */
    func pushNotification(type: NotificationType) {
        let message: String
        let backgroundColor: UIColor
        var textColor = UIColor(Color.XMDesgin.f1)
        var font = UIFont.preferredFont(forTextStyle: .body)

        switch type {
        case let .info(msg):
            message = msg
            textColor = UIColor(Color.XMDesgin.b1)
            backgroundColor = UIColor(Color.XMDesgin.f1)
        case let .success(msg):
            message = msg
            backgroundColor = UIColor(Color.green)


        case let .warning(msg):
            message = msg
            backgroundColor = UIColor(Color.orange)

        case let .error(msg):
            message = msg
            backgroundColor = UIColor(Color.red)

        case let .loading(msg):
            message = msg
            textColor = UIColor(Color.green)
            backgroundColor = UIColor(Color.XMDesgin.b1)
        }

        // update default style
        NotificationPresenter.shared.updateDefaultStyle { style in
            let style: StatusBarNotificationStyle = style
            style.backgroundStyle.backgroundColor = backgroundColor
            style.textStyle.textColor = textColor
            style.textStyle.font = font
            style.canSwipeToDismiss = false
            style.animationType = .move
            return style
        }

        switch type {
        case .info, .error, .success, .warning:
            NotificationPresenter.shared.present(message, subtitle: nil, styleName: nil, duration: 2, completion: { _ in
                // completion block
            })

        case let .loading(msg):
            NotificationPresenter.shared.present(msg)
            NotificationPresenter.shared.displayActivityIndicator(true)
        }
    }
    
    func pushProgressNotification(text:String,progress:@escaping(NotificationPresenter)->()) {
        // update default style
        NotificationPresenter.shared.updateDefaultStyle { style in
            let style: StatusBarNotificationStyle = style
            style.backgroundStyle.backgroundColor = UIColor(Color.XMDesgin.b1)
            style.textStyle.textColor = UIColor(Color.green)
            style.textStyle.font = UIFont.boldSystemFont(ofSize: 16)
            style.canSwipeToDismiss = false
            style.animationType = .fade
            return style
        }
        NotificationPresenter.shared.present(text) { presenter in
            progress(presenter)
        }

    
    }

    /*
     点击查看图片详情
     */
    func tapToShowImage(tapUrl: String, rect: CGRect? = nil, urls: [String]? = nil) {
        let lantern = Lantern()

        lantern.numberOfItems = {
            if let urls {
                return urls.count
            } else {
                return 1
            }
        }
        lantern.reloadCellAtIndex = { context in
            let urlStr = urls?[context.index] ?? tapUrl
            // 调用 KingfisherManager.shared.retrieveImage 方法
            guard let url = URL(string: urlStr) else { return }
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case let .success(imageResult):
                    // 成功下载图片，获取 UIImage
                    let uiImage = imageResult.image
                    // 使用获取到的UIImage进行后续操作
                    let lanternCell = context.cell as? LanternImageCell
                    lanternCell?.imageView.image = uiImage

                    guard let rect else { return }
                    lantern.transitionAnimator = LanternSmoothZoomAnimator(transitionViewAndFrame: { _, _ -> LanternSmoothZoomAnimator.TransitionViewAndFrame? in
                        let transitionView = UIImageView(image: uiImage)
                        transitionView.contentMode = transitionView.contentMode
                        transitionView.clipsToBounds = true
                        let thumbnailFrame = rect
                        return (transitionView, thumbnailFrame)
                    })
                case let .failure(error):
                    // 下载图片失败，处理错误
                    print("Error: \(error)")
                }
            }
        }
        lantern.pageIndex = urls?.firstIndex(of: tapUrl) ?? 0
        lantern.transitionAnimator = LanternFadeAnimator()
        lantern.pageIndicator = LanternNumberPageIndicator()
        lantern.show()
    }
}

#Preview {
    List {
        let msg = String.randomChineseString(length: 12)
        XMDesgin.XMListRow(.init(name: "Info", icon: "", subline: "")) {
            Apphelper.shared.pushNotification(type: .info(message: msg))
        }
        XMDesgin.XMListRow(.init(name: "Success", icon: "", subline: "")) {
            Apphelper.shared.pushNotification(type: .success(message: msg))
        }
        XMDesgin.XMListRow(.init(name: "Warning", icon: "", subline: "")) {
            Apphelper.shared.pushNotification(type: .warning(message: msg))
        }
        XMDesgin.XMListRow(.init(name: "Error", icon: "", subline: "")) {
            Apphelper.shared.pushNotification(type: .error(message: msg))
        }
        XMDesgin.XMListRow(.init(name: msg, icon: "", subline: "")) {
            Apphelper.shared.pushNotification(type: .loading(message: "正在加载..."))
        }
        XMDesgin.XMListRow(.init(name: "Progress", icon: "", subline: "")) {
            Apphelper.shared.pushProgressNotification(text:"正在加载...") { presenter in
                presenter.displayProgressBar(at: 0.4)
            }
        }
        
        
    }
}
