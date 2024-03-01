//
//  AppDelegate.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/24.
//

import AliyunOSSiOS
import Foundation
import TUIChat
import TUICore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DAppInit()
        // 在应用程序启动时执行一些配置
        return true
    }
}

func DAppInit() {
    TUIInit()
    OSSLog.enable()
    changeNavigaitonBarBackIcon()
}

func changeNavigaitonBarBackIcon() {
    let backBarBtnImage = UIImage(named: "system_backbar")?
        .withRenderingMode(.alwaysTemplate).withTintColor(.white)
    UINavigationBar.appearance().backIndicatorImage = backBarBtnImage
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = backBarBtnImage
}

func TUIInit() {
    TUILogin.login(Int32(Int(AppConfig.TIMAppID)!), userID: "liseami", userSig: "eJwtjF0LgjAYRv-LbgudcysUvAyJIgrFSLxxbMarLkzX6IP*e0u9fM55OB*U7hPHyB6FiDgYLccNQt40VDDiFgZZKpjVIJqy60Cg0FthjAkNPDoZ*eygl5YzxohVE9Wg-myNA3tmvj9X4GrLm1oPPF*c21PabPPDPU64oHGNX8bwd*FmhVvtjg*jeKbJJULfHyapM7o_") {}

    TUIConfig.default().avatarType = .TAvatarTypeRounded
    TUIChatConfig.default().backgroudColor = .black

    if let customChatThemePath = Bundle.main.path(forResource: "TUIChatXMTheme.bundle", ofType: nil),
       let customConversationThemePath = Bundle.main.path(forResource: "TUIConversationXMTheme.bundle", ofType: nil),
       let customCoreThemePath = Bundle.main.path(forResource: "TUICoreXMTheme.bundle", ofType: nil)
    {
        TUIThemeManager.share().registerThemeResourcePath(customChatThemePath, for: .chat)
        TUIThemeManager.share().registerThemeResourcePath(customConversationThemePath, for: .conversation)
        TUIThemeManager.share().registerThemeResourcePath(customCoreThemePath, for: .core)
    }

    TUIThemeManager.share().applyTheme("dark", for: .all)
    TUITextMessageCell.outgoingTextFont = .boldSystemFont(ofSize: 16)
    TUITextMessageCell.outgoingTextColor = UIColor(Color.XMDesgin.f1)
    TUITextMessageCell.incommingTextFont = .boldSystemFont(ofSize: 16)
    TUITextMessageCell.incommingTextColor = UIColor(Color.XMDesgin.f1)
    TUIMessageCell.outgoingNameFont = .boldSystemFont(ofSize: 16)
    TUIMessageCell.outgoingNameColor = UIColor(Color.XMDesgin.f1)
    TUIMessageCell.incommingNameFont = .boldSystemFont(ofSize: 16)
    TUIMessageCell.incommingNameColor = UIColor(Color.XMDesgin.f1)

    TUIMessageCellLayout.outgoingMessage().avatarSize = .init(width: 80, height: 80)
    TUIMessageCellLayout.outgoingMessage().avatarInsets = .init(horizontal: 16, vertical: 16)
    TUIMessageCellLayout.outgoingTextMessage().avatarSize = .init(width: 80, height: 80)
    TUIMessageCellLayout.outgoingTextMessage().avatarInsets = .init(horizontal: 16, vertical: 16)
    TUIMessageCellLayout.incommingTextMessage().avatarSize = .init(width: 80, height: 80)
    TUIMessageCellLayout.incommingTextMessage().avatarInsets = .init(horizontal: 16, vertical: 16)
}
