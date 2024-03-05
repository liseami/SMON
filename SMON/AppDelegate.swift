//
//  AppDelegate.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/24.
//

import AliyunOSSiOS
import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DAppInit()
        // 在应用程序启动时执行一些配置
        // 请求用户位置
        
        print(String(describing: type(of: XMUser.init())))
        return true
    }
}

func DAppInit() {
//    OSSLog.enable()
    changeNavigaitonBarBackIcon()
}

func changeNavigaitonBarBackIcon() {
    let backBarBtnImage = UIImage(named: "system_backbar")?
        .withRenderingMode(.alwaysTemplate).withTintColor(.white)
    UINavigationBar.appearance().backIndicatorImage = backBarBtnImage
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = backBarBtnImage
}

