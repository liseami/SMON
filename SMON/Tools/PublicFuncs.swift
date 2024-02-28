//
//  PublicFuncs.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation
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

    func findGlobalNavigationController() -> UINavigationController? {
        // 获取主窗口场景
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return nil
        }

        // 递归查找包含 UINavigationController 的视图控制器
        func findNavigationController(from viewController: UIViewController?) -> UINavigationController? {
            if let navigationController = viewController as? UINavigationController {
                return navigationController
            }

            for child in viewController?.children ?? [] {
                if let navigationController = findNavigationController(from: child) {
                    return navigationController
                }
            }

            return nil
        }

        // 从主窗口的根视图控制器开始查找
        return findNavigationController(from: window.rootViewController)
    }
}
