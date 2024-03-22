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
import StoreKit
import SwiftUIX
import UIKit

/*
 模拟延时
 */
func waitme(sec: Double = 3) async {
    await SwiftUI.Task.sleep(UInt64(sec * 1000000000)) // 等待1秒钟
}

/*
 强制等待任务
 */
@MainActor public func LoadingTask(loadingMessage: String, task: @escaping () async -> Void) {
    guard let window = Apphelper.shared.getWindow() else { return }

    // 创建模糊效果的视图
    if let blurView = VisualEffectBlurView(blurStyle: .dark)
        .edgesIgnoringSafeArea(.all).host().view
    {
        blurView.size = CGSize(width: Screen.main.bounds.width, height: Screen.main.bounds.height)
        blurView.backgroundColor = UIColor.clear
        blurView.alpha = 0.0 // 初始时设置为透明
        blurView.tag = 1
        blurView.center = CGPoint(x: Screen.main.bounds.width * 0.5, y: Screen.main.bounds.height * 0.5)

        // 将模糊效果的视图添加到窗口上
        window.addSubview(blurView)

        // 显示loading消息
        Apphelper.shared.pushNotification(type: .loading(message: loadingMessage))

        // 使用UIView.animate实现渐显动画
        UIView.animate(withDuration: 1) {
            blurView.alpha = 1.0 // 设置为完全不透明
        }
        // 异步执行任务
        SwiftUI.Task { @MainActor in
            await waitme()
            await task()
            // 使用UIView.animate实现淡出动画
            UIView.animate(withDuration: 0.3) {
                blurView.alpha = 0.0 // 设置为透明
            } completion: { _ in
                blurView.removeFromSuperview() // 移除模糊效果的视图
                NotificationPresenter.shared.dismiss() // 关闭loading消息
            }
        }
    }
}

class Apphelper {
    static let shared: Apphelper = .init()

    /*
     关闭键盘
     */

    func closeKeyBoard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    /*
     弹出Alert弹窗
     */

    @MainActor
    func pushAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        actions.forEach { UIAlertAction in
            alertController.addAction(UIAlertAction)
        }
        topMostViewController()?.present(alertController, animated: true, completion: nil)
    }

    /*
     请求用户评分
     */

    func requestReviewApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }

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
    @MainActor
    func pushNotification(type: NotificationType) {
        let message: String
        let backgroundColor: UIColor
        var textColor = UIColor(Color.XMDesgin.f1)

        switch type {
        case let .info(msg):
            message = msg
            textColor = UIColor(Color.XMDesgin.f1)

        case let .success(msg):
            message = msg
            textColor = UIColor(Color.green)

        case let .warning(msg):
            message = msg
            textColor = UIColor(Color.orange)

        case let .error(msg):
            message = msg

            textColor = UIColor(Color.red)

        case let .loading(msg):
            message = msg
            textColor = UIColor(Color.green)
        }

        // update default style
        NotificationPresenter.shared.updateDefaultStyle { style in
            let style: StatusBarNotificationStyle = style
            style.backgroundStyle.backgroundColor = UIColor(Color.XMDesgin.b1)
            style.textStyle.textColor = textColor
            style.textStyle.font = .monospacedSystemFont(ofSize: 15, weight: .bold)
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

    func pushProgressNotification(text: String, progress: @escaping (NotificationPresenter) -> Void) {
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
    @MainActor
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

    func pushActionSheet(title: String?, message: String?, actions: [UIAlertAction], completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.overrideUserInterfaceStyle = .dark
        for action in actions {
            alertController.addAction(action)
        }

        alertController.addAction(.init(title: "取消", style: .cancel, handler: { _ in

        }))

        // 设置模式为黑暗模式
        alertController.view.tintColor = UIColor(Color.XMDesgin.f1)

        if let viewController = topMostViewController() {
            alertController.popoverPresentationController?.sourceView = viewController.view
            alertController.popoverPresentationController?.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            alertController.popoverPresentationController?.permittedArrowDirections = []
        }

        topMostViewController()?.present(alertController, animated: true, completion: completion)
    }

    /*
     根据城市Id，返回城市名称
     */
    func cityName(forCityID cityID: String) -> String? {
        let provinces = MockTool.readArray(Province.self, fileName: "省份&城市") ?? []
        for province in provinces {
            if let city = province.children.first(where: { $0.id == cityID }) {
                return city.name
            }
        }
        return nil
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
            Apphelper.shared.pushProgressNotification(text: "正在加载...") { presenter in
                presenter.displayProgressBar(at: 0.4)
            }
        }
        XMDesgin.XMListRow(.init(name: "ShowActionSheet", icon: "", subline: "")) {
            Apphelper.shared.pushActionSheet(title: "操作表单", message: "hello,world", actions: [UIAlertAction(title: "保存", style: .default, handler: { _ in
            }), UIAlertAction(title: "删除", style: .destructive, handler: { _ in

            })])
        }
        XMDesgin.XMListRow(.init(name: "强制等待任务", icon: "", subline: "")) {
            LoadingTask(loadingMessage: "请等待") {}
        }
    }
}
