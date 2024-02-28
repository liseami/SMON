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
    @ObservedObject var userManager: UserManager = .shared

    var body: some Scene {
        WindowGroup {
            Group {
//                if userManager.user.isLogin {
//                    // 需要进入资料流程
//                    if userManager.user.needInfo {
//                        UserInfoRequestMainView()
//                    } else {
//                        MainView()
//                    }
//                } else {
//                    LoginMainView()
//                }
                UserInfoRequestMainView()
            }
            .tint(Color.XMDesgin.f1)
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
