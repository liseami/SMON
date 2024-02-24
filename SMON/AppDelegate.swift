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
//    config.logListener(BIMLogLevel.LOG_DEBUG, "")
    BIMClient.sharedInstance().initSDK(Int32(889305), config: config)
    // 火山用户IM登陆
    BIMClient.sharedInstance().login("15207113458", token: "Bwm7M77IIlNMW9TC8kDwGFxjA52CO7O8CHd0RocCdebpsYbAR5ZpPx") { error in
        print(error?.description ?? "")
    }
}
