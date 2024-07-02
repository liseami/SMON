//
//  RecommendRecordAPI.swift
//  SMON
//
//  Created by mac xiao on 2024/7/1.
//

import Foundation
enum RecommendRecordAPI: XMTargetType {
    case salutation(toUserId: String)

    var group: String {
        return "/v2/recommendRecord"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .salutation(let toUserId): return ["toUserId": toUserId]
        default: return nil
        }
    }
}
