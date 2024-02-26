//
//  AppDelegate.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DAppInit()
        // 在应用程序启动时执行一些配置
        return true
    }
}

func DAppInit() {
//    // 火山引擎IM注册
    let config = BIMSDKConfig()
    config.enableAppLog = true
    BIMClient.sharedInstance().initSDK(Int32(889305), config: config)
    // 火山用户IM登陆
    BIMClient.sharedInstance().login("2", token: "GqiiGE7ELTxOUSlJ9XDO1FpENkL7BrcXhTtmW5K597iAN5Taj04yuZ") { error in
        print(error?.description ?? "")
    }
    BIMClient.sharedInstance().addConversationListener(BIMConversationListener())
    BIMClient.sharedInstance().setUserSelfPortrait("https://i.pravatar.cc/300") { _ in
    }
    BIMClient.sharedInstance().setUserSelfNickName("赵纯想") { error in
        print(error?.description ?? "" + "🌞")
    }
}
