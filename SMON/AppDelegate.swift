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
        let entity = JPUSHRegisterEntity()
        entity.types = 3
        JPUSHService.setup(withOption: launchOptions, appKey: AppConfig.JPUSHAPPKE, channel: "ios", apsForProduction: true)
        JPUSHService.registrationIDCompletionHandler { _, _ in }
        let _ = IAPManager.shared
        let _ = ConfigStore.shared
        let _ = UserManager.shared
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
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

extension AppDelegate: JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> Int {
        // Required
        if let userInfo = notification.request.content.userInfo as? [AnyHashable: Any], let _ = notification.request.trigger as? UNPushNotificationTrigger {
            print(userInfo.description)
            // 在这里处理打开通知后的跳转
            print(userInfo.description)
            JPUSHService.handleRemoteNotification(userInfo)
        }
//           completionHandler([.alert]) // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
        return 3
    }

    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // Required
        if let userInfo = response.notification.request.content.userInfo as? [AnyHashable: Any], let _ = response.notification.request.trigger as? UNPushNotificationTrigger {
            print(userInfo.description)
            print(userInfo.description)
            JPUSHService.handleRemoteNotification(userInfo)
        }
    }

    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
        if let _ = notification.request.trigger as? UNPushNotificationTrigger {
            // 从通知界面直接进入应用
        } else {
            // 从通知设置界面进入应用
        }
    }

    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable: Any]?) {
        print(info)
    }
}
