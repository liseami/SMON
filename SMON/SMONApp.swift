//  SMONApp.swift
//  SMON
//  Created by 赵翔宇 on 2024/2/22.

@_exported import Combine
@_exported import KakaJSON
@_exported import Pow
@_exported import SwifterSwift
@_exported import SwiftUI


@main
struct SMONApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var userManager: UserManager = .shared
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            Group {
                if userManager.logged{
                   // 已登录用户
                    // 需要进入资料流程
                    if userManager.userLoginInfo.isNeedInfo {
                        // 需要进入资料流程
                        UserInfoRequestMainView()
                    } else {
                        // APP正式页面
                        MainView()
                    }
                } else {
                    // 登录页面
                    LoginMainView()
                }
            }
            .tint(Color.XMDesgin.f1)
            .preferredColorScheme(.dark)
        }
        // 场景状态改变
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .background:
                print("进入background")
            case .inactive:
                print("进入inactive")
             
            case .active:
                NotificationCenter.default.post(name: Notification.Name.APP_GO_TO_ACTIVE, object: nil, userInfo: nil)
                print("进入active")
            @unknown default:
                break
            }
        }
    }
}
