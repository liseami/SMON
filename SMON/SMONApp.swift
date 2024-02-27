//
//  SMONApp.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

@main
struct SMONApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var userManager: UserManager = .init()

    var body: some Scene {
        WindowGroup {
            Group {
                if userManager.user.isLoggedIn {
                    MainView()
                } else {
                    LoginMainView()
                }
            }
            .tint(.white)
            .environment(\.colorScheme, .dark)
        }
    }
}

// 修改NavigationBackBar的式样
extension UINavigationController {
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let backBarBtnImage = UIImage(named: "system_backbar")?
            .withRenderingMode(.alwaysTemplate).withTintColor(.white)
        UINavigationBar.appearance().backIndicatorImage = backBarBtnImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backBarBtnImage
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
