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
    var blurredWindow: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DAppInit()
        let _ = ConfigStore.shared
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
