//
//  NDTargetType.swift
//  SwiftUIRoute
//
//  Created by 梁泽 on 2023/9/27.
//

import Moya
import SwifterSwift
import TIMCommon

public typealias HTTPRequestMethod = Moya.Method

public protocol XMTargetType: TargetType {
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
    var group: String { get }
    func updatingParameters(_ newPage: Int) -> XMTargetType
}

// MARK: - 自有扩展

extension XMTargetType {
    var parameters: [String: Any]? { nil }

    func updatingParameters(_ newPage: Int) -> XMTargetType {
        return self
    }


    var parameterEncoding: ParameterEncoding {
        switch method {
        case .get: return URLEncoding.default
        default: return JSONEncoding.default
        }
    }

    var enumName: String {
        String(describing: self).components(separatedBy: "(").first!
    }
}

// MARK: - Moya 扩展

extension XMTargetType {
    var baseURL: URL {
        URL(string: AppConfig.baseUrl) ?? URL(string: "https://test.com")!
    }

    var path: String {
        return group + "/" + enumName
    }

    var group: String { "" }

    var sampleData: Data {
        "".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        switch method {
        case .get:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        case .post, .put, .delete:
            return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)

        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var headers: [String: String] = [:]
        // 时间戳 10 位
        let timestamp = String(Int(Date.now.timeIntervalSince1970))
        // Noce 16位随机字符串，数字字母
        let nonce = String.randomString(length: 16)
        // 盐
        let SIGN_SALT = AppConfig.readPlist(key: "SMONMeiridasai")
        // 前面三个加起来 md5()
        let sign = (nonce + timestamp + SIGN_SALT).md5()

        // Timestamp
        headers["Timestamp"] = timestamp
        // Nonce
        headers["Nonce"] = nonce
        // Sign
        headers["Sign"] = sign

        // 常规信息
        let standardHeader = [
            "version": AppConfig.AppVersion.replacingOccurrences(of: ".", with: ""),
            "device": "ios",
            "os": "iOS" + UIDevice.current.systemVersion,
            "model": UIDevice.current.modelName,
            "DeviceToken": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        headers["Client-Info"] = standardHeader.jsonString()

#if targetEnvironment(simulator)
        headers["Token"] = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJpb3pDVHF1QTgrNTAvOWgyazhnR1dtU3JTNWY4cHQ0SklVR212ZExLWjB5L25BbUdZY3R0NnNyNDlyV25jU05Mc3hEaDlyWFlQMDdiNUh3NHVxYkZPMnlDSC9MWDVDOEZLdEUyQnRJbDkvazM1dFplS1pDS2FrRWV2V1RFa3BJMlVRU0FTT0lPdXNPbGM0eDZWZzNScHdCc2F0MlVyUW9Bc1NPS0FPTVV5QmV3M0VzQmZxOE04dnJSY3ZObHYwNG5va3c1R0FZLzdlNUtid041ekNFdDNFb0hKZHlwK1FjYys0bmNObFlVZERQYlZ4dDBtRzV3aTZhR3pvRHFvUU5EdWMxdmJrT0pmUCtUSVZGTlhzOHRpcmtBd1l1alhoeUd5MEQ5Yi81d3pnSmFTdWduVkZwUlhLbVBaQjlmdHRseXhPOWluTXdPWUo0aXluRzQyZTlxUkE9PSIsImV4cCI6MTcxMjM5NjU5NH0.P9SlVrPuhnOA3Mc-5WnoORChH-j3pZfiL2cLNPpZ27g"
#else
        if !UserManager.shared.userLoginInfo.token.isEmpty {
            headers["Token"] = UserManager.shared.userLoginInfo.token
        }
#endif

        return headers
    }
}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)

        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }
}
