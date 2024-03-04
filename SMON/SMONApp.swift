//
//  SMONApp.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

@_exported import Combine
@_exported import Pow
@_exported import SwiftUI
@_exported import SwifterSwift



@main
struct SMONApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var userManager: UserManager = .shared

    var body: some Scene {
        WindowGroup {
            Group {
                if userManager.user.isLogin {
                    // 需要进入资料流程
                    if userManager.user.isNeedInfo {
                        UserInfoRequestMainView()
                    } else {
                        MainView()
                    }
                    
//                    MainView()
                } else {
                    LoginMainView()
                }
            }
            .tint(Color.XMDesgin.f1)
            .preferredColorScheme(.dark)
        }
    }
}


