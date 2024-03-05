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

protocol XMTargetType: TargetType {
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding { get }
    var group: String { get }
}

// MARK: - 自有扩展

extension XMTargetType {
    var parameters: [String: Any]? { nil }

    var parameterEncoding: ParameterEncoding {
        switch method {
        case .get: return URLEncoding.default
        default: return JSONEncoding.default
        }
    }
    
    var enumName : String {
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
        let timestamp = String(Int(Date.now.timeIntervalSince1970))
        let nonce = String.randomString(length: 16)
        let SIGN_SALT = AppConfig.readPlist(key: "SMONMeiridasai")
        let sign = (nonce + timestamp + SIGN_SALT).md5()

        // Timestamp
        headers["Timestamp"] = timestamp
        // Nonce
        headers["Nonce"] = nonce
        // Sign
        headers["Sign"] = sign

        // 常规信息
        let standardHeader = [
            "version": AppConfig.AppVersion,
            "device": UIDevice.current.name,
            "os": UIDevice.current.systemVersion,
            "model": UIDevice.current.modelName,
            "DeviceToken": UIDevice.current.identifierForVendor?.uuidString ?? ""
        ]
        headers["Client-Info"] = standardHeader.jsonString()

#if targetEnvironment(simulator)
        headers["Token"] = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJNMGRMT1V1MFRvN3oyWmowVE04NmUwNHJ5TUlhRnFHYlR6d2crbEZaZnhyZXJXT0RmK1hLc25JT2czOUVmTnRnT2sxcFVDcmt0R3E2SWpPVXJYWG5nVk5FUWRmWGJwQUU4cENSSTh0dVlCeDhnN1lsTGM2K2lMRi95TmpuN2xkN05Kei8yTUdyNUdkVE00Rk4ydTRMMlREYnBJN1NTaTV3UjFKNDBiazhXOVN0OFdFQ3gwMEd5cjFtNU13UklwS0luUS9ZL1pJVTVoMzFVWk55WjEzaDQ2WFNxL1ppZHNVdkE4ZU9qeFJ3dVl1TXBPR2tmekV4TU9nMEU3c3lZVlFhK2l2OFFTbG1XRnVRNEhJTXZHYlVXcVd2Tkl3MmJSM2p2ZDAxenRYMTV5b1BwdWt0bzVoUFNST2tFQThjS2tERzRKNkNtamlkNlF4U1c4RDhVRExza2c9PSIsImV4cCI6MTcxMjE5OTU0MX0.uO-L9ftQXfV49-Xz7Fur0gKOJ6vEFSZK5P5gClWCzek"
#else
        if !UserManager.shared.user.token.isEmpty {
            headers["Token"] = UserManager.shared.user.token
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
