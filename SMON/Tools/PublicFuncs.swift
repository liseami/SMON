//
//  PublicFuncs.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation
import JDStatusBarNotification
import PanModal
import SwiftUIX
import UIKit

class Apphelper {
    static let shared: Apphelper = .init()
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

    func present<V: View>(_ view: V,
                          named name: AnyHashable? = nil,
                          onDismiss: @escaping () -> Void = {},
                          presentationStyle: ModalPresentationStyle? = nil,
                          completion: @escaping () -> Void = {})
    {
        topMostViewController()?.present(view.environment(\.colorScheme, .dark), named: name, onDismiss: onDismiss, presentationStyle: presentationStyle, completion: completion)
    }

    enum NotificationType {
        case success(message: String)
        case info(message: String)
        case warning(message: String)
        case error(message: String)
    }

    func presentPanSheet<T: View>(_ view: T) {
        /*
         推送PanSheet页面
         */
        topMostViewController()?.presentPanModal(PanViewBox(content: view))
    }

    func pushNotification(type: NotificationType) {
        let message: String
        let backgroundColor: UIColor
        let textColor: UIColor
        let font: UIFont

        switch type {
        case let .success(msg):
            message = msg
            backgroundColor = UIColor(Color.XMDesgin.b1)
            textColor = UIColor(Color.XMDesgin.f1)
            font = UIFont.preferredFont(forTextStyle: .title3).bold
        case let .info(msg):
            message = msg
            backgroundColor = UIColor(Color.XMDesgin.b1)
            textColor = UIColor(Color.XMDesgin.f1)
            font = UIFont.preferredFont(forTextStyle: .title3).bold
        case let .warning(msg):
            message = msg
            backgroundColor = UIColor(Color.XMDesgin.b1)
            textColor = UIColor(Color.XMDesgin.f1)
            font = UIFont.preferredFont(forTextStyle: .title3).bold
        case let .error(msg):
            message = msg
            backgroundColor = UIColor(Color.XMDesgin.b1)
            textColor = UIColor(Color.XMDesgin.f1)
            font = UIFont.preferredFont(forTextStyle: .title3).bold
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

        NotificationPresenter.shared.present(message, subtitle: nil, styleName: nil, duration: 2, completion: { _ in
            // completion block
        })
    }
}
