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
    static var key =
    "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2qEqUzgpnnQDmCqVvi7fhKAqDLUZsZzRJVrzUL4Orc73Vjt+BhNocQL0B+77Q2etQuh6BcZXR8Ct2XHl6h1nPqoFZ0VW37NbAFKZfe9Lji/7Zj2ze3PsAvMMhwWnA8lfxce446pEe176SeD9E5YnbCtHanR5JRUPyi9my4Xv6+WDNDsiXA+6cHccMtHGg9a7Zmfl+8VzFVRBLLCX951TfGiqLE5iHP4c1jVamCMOEPw5VnFMZA5ZJ+jwdtTc5jSSSJNsNFQh0awjGqhQaUcktQvmD4tJPDvcmd8uzYFvQFgbgQe9ex+etlRQupicgB/NzEaMGOORBsmOIPa8nWP9xAgMBAAECggEAXPR4QBI7KU+1TVzNpF6uTV9bOjaoSDKdYVVK85DaqT5VtYDoLbm2ZfpsNb4v9YlxP7v4Glf7rsNS2wFksP6ArjZPba4iuV9GSqo3oRAa2sI8B+v9s80xz8ZAZ8VOVGsAZldcrIpzIAcbbN7VE/LcnSR8d4zOBOvDEIQrXeVyet3frVQItFCZjdl/BpRzQhuBCr4uiLCMybQAKU9a49C9H/oJ4sjwSipZQzbYyqktPhhUEqAbg699up10LhJPj6fNiiPrK90cEafn4Nt43JI+84E8mmHKDWiAzWXtz5rHuRzyZ29mb6nvnyVKnK0IujV5JoGmbCII24Ff08GrEK6/gQKBgQD8iqxXCKPl7Ij4J7rnlnutOPv8M5Gy/WC36TP7wkmCuek56u387rgW50VlZq1bRWCM6Bw4Poa3n2xZ+mFK78GzP1YimlY93XBoQ//X7pEGEpDPJr8uy4vnOjwUnK73Ll+Q/7uuwzyHdRMfBbWn/3xzzAYhQIUXj5IB/lHaqR5/rQKBgQC5KKCKLVghA679r1dKnrgf6fEAAUOexa0pbZQqFfJuO5xS9djzMqMLfxj/a61C+lvwy3r2CtoyCfRBeU6pCLWqSv9vj7oAkyQv00PMGvcj9UxqYdGBYNwNe5BOt9EVY3kW2VN8fDmHFQn1JRLXnlFCpW1JyZFAV2nL6lEJGYJnVQKBgQCT0Td+2ffVJNYnKlokI9jQU4Jq5GRruBNckoty2Q3eDqOM2w3h9niaL1RXPfpKahlRYKrj4PVJlW7+W6eHDT77hB8Osfe4zlx1Kxgdc+4+9677EVrmMQ36kgOIrQ1ccTBO1uEsMerD/qrqhZUGeGyH+uu7muBMIiT8NbgDnOnVIQKBgBKcJb6dnhz7XMw8ol5qo4D5p3JjriM4JRZj4B92wz4XGbgw45RWA5M1PBL4BJsVxMXn/bzbDGE5JOarxZ8xs+igzxmsbXp/T4TLDCZok2x2zC5pFICXdqaYQ8HVsdsfe10zjLOXXMTZ9X1BM6qeS/aR3/EppEK+RnDrZSev+65dAoGBAPN+9xK1Si1B6VJnZJRTEaWH6c4y9ZaOQgEOOy2UHOWPJcdCIjhpO8CUstnTSdo7xhgnTbyf/hyEUSDbLemwrmFfIhXQ/qvawZIRW3nJhGtzGLY7LBF1TpNqeCPCNsfYcei/AvDm75xedqGA6ZLcxqRSb/9II2m1nddFQIWB0aBM"
    // baseURL
    static var baseUrl: String {
        switch env {
//        case .dev: return "https://mrdstest.aishisan.cn"
        case .dev : return "https://meiridasai.aishisan.cn"
        case .prod: return "https://meiridasai.aishisan.cn"
        }
    }

    /// 极光APPKEY
    static var TIMAppID: String {
        self.readPlist(key: "TIMAppID")
    }
    
    static var JPUSHAPPKE : String {
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
