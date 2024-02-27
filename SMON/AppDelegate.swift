//
//  AppDelegate.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/24.
//

import Foundation
import TUICore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DAppInit()
        // 在应用程序启动时执行一些配置
        return true
    }
}

func DAppInit() {
    TUILogin.login(Int32(1600024914), userID: "liseami", userSig: "eJwtjF0LgjAYRv-LbgudcysUvAyJIgrFSLxxbMarLkzX6IP*e0u9fM55OB*U7hPHyB6FiDgYLccNQt40VDDiFgZZKpjVIJqy60Cg0FthjAkNPDoZ*eygl5YzxohVE9Wg-myNA3tmvj9X4GrLm1oPPF*c21PabPPDPU64oHGNX8bwd*FmhVvtjg*jeKbJJULfHyapM7o_") {}

    if let customThemePath = Bundle.main.path(forResource: "TUIChatXMTheme.bundle", ofType: nil) {
        TUIThemeManager.share().registerThemeResourcePath(customThemePath, for: .chat)
    }
    TUIThemeManager.share().applyTheme("dark", for: .all)
    
}
