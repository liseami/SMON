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
        let timestamp = (Date.now.timeIntervalSince1970 * 1000 ).int.string
        // Noce 16位随机字符串，数字字母
        let nonce = String.randomString(length: 32)
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
        headers["Token"] = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJMR3B3TXNjME9wSlVrQ1ZicUdsVzZCQllUaTh0QWE1TDArTXg4TU0xcWJSNlVkL1N4T2c3TDZqQ1RJQ2ZIT2FaS0poV09qaUk2c3lVdFNoOW1kM3JDZFVVbTkzWExrMUtEQnlFbjhGMHFjQW9SdkQzbkJWSjdPbC93a2Y1QjlETEgyVVkzMGx4aFhDNVY4d3I4dm1hMmo4aERsZzIwWDNON20xelFuTnhWSjBGRlJKU28xUWpRWVE0bnNxYmVwTXJMNkh5SXJWVk5pOTU2ajVuaER2TFR4VmJXNnJrZTBmTjVNUGg2MzB4TUNmODFFeG5MemhRZUJ4ai9nWjBUSDgrSVJJZll1RHc4eU9mUUg2UVN2NTdodURxM1JIVXVoYkF5YnpjVlZuclNZSFJubmlXOHl0LzQ0QzJodnZIQXdWQlVQZGtISmdHVmFqUEFKWEVxd0FiSmc9PSIsImV4cCI6MTcxNjY5OTg2OH0.PQeCkSOBxwSW4GLqFDYIDkp1J4Ltm6evRyoit7H-Gx8"
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
