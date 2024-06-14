//
//  AppConfig.swift
//  Looper
//
//  Created by 赵翔宇 on 2022/6/20.
//

import Foundation

public enum AppConfig {
    #if DEBUG
        static let env = Env.dev
    #else
        static let env = Env.prod
    #endif

    // 环境
    public enum Env {
        case dev
        case prod
    }

    // baseURL
    static var baseUrl: String {
        if UserManager.shared.isAppleUser {
            return "https://mrdstest.aishisan.cn"
        } else {
            switch env {
            case .dev: return "https://mrdstest.aishisan.cn"
//                    case .dev: return "https://meiridasai.aishisan.cn"
            case .prod: return "https://meiridasai.aishisan.cn"
            }
        }
    }

    /// 极光APPKEY
    static var TIMAppID: String {
        self.readPlist(key: "TIMAppID")
    }

    static var JPUSHAPPKE: String {
        self.readPlist(key: "JPUSHAPPKE")
    }

    static func readPlist(key: String) -> String {
        guard let path = Bundle.main.path(forResource: "AppConfig", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let value = configDict[key] as? String
        else { return "" }
        return value
    }

    /// 主页
    static let domain: String = "https://ismonlove.com/"
    /// 用户协议
    static let UserAgreement: String = domain + "work/YHXY"
    /// 隐私政策
    static let UserPrivacyPolicy: String = domain + "work/YSZC"
    /// 赛币充值协议
    static let SAIBICOIN: String = domain + "work/SBXY"
    /// 当前版本
    static var AppVersion: String { (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0.0" }
    /// AppID
    static var AppleStoreAppID: String { "6479641187" }
    /// 商店链接
    static var AppStoreURL: URL { URL(string: "https://apps.apple.com/cn/app/id" + AppleStoreAppID)! }
    /// 测试图片
    static var mokImage: URL? {
        let int = Int.random(in: 180 ... 220)
        return URL(string: "https://picsum.photos/\(int)/\(int)")
    }
}
