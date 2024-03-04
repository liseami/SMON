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
        switch env {
        case .dev: return "https://37z71b5291.imdo.co"
        case .prod: return "https://app.naduo.love"
        }
    }
    
    

    /// 极光APPKEY
    static var TIMAppID: String {
        self.readPlist(key: "TIMAppID")
    }

    /// 极光APPKEY
    static var JGuangAppKey: String {
        self.readPlist(key: "JGuangAppKey")
    }

    /// 微信APPID
    static var WeChatAppID: String {
        self.readPlist(key: "WeChatAppID")
    }

    /// 微信WeChatAppSecret
    static var WeChatAppSecret: String {
        self.readPlist(key: "WeChatAppSecret")
    }

    /// 高德地图Key
    static var AMapKey: String {
        self.readPlist(key: "AMapKey")
    }

    // 友盟AppKey
    static var UMAppKey: String {
        self.readPlist(key: "UMAppKey")
    }

    /// MapBoxPublicToken
    static var MapBoxPublicToken: String {
        self.readPlist(key: "MapBoxPublicToken")
    }

    private static func readPlist(key: String) -> String {
        guard let path = Bundle.main.path(forResource: "AppConfig", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let value = configDict[key] as? String
        else { return "" }
        return value
    }

    /// 主页
    static let domain: String = "https://naduo.love/"
    /// 用户协议
    static let UserAgreement: String = domain + "articles/UserAgreement"
    /// 隐私政策
    static let UserPrivacyPolicy: String = domain + "articles/PrivacyPolicy"
    /// 隐私政策
    static let RechargeProtocol: String = domain + "articles/RechargeProtocol"
    /// 当前版本
    static var AppVersion: String { (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0.0" }
    /// AppID
    static var AppleStoreAppID: String { "6446198565" }
    /// 商店链接
    static var AppStoreURL: URL { URL(string: "https://apps.apple.com/cn/app/id" + AppleStoreAppID)! }
    /// 测试图片
    static var mokImage: URL? {
        let int = Int.random(in: 180 ... 220)
        return URL(string: "https://picsum.photos/\(int)/\(int)")
    }
}
