//
//  UserRelationAPI.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/20.
//

import Foundation
import KakaJSON
import Moya
import SwiftyJSON

enum UserRelationAPI: XMTargetType {

    case tapFollow(followUserId: String)
    case followersList(lastUserId: String)
    case fansList(lastUserId: String)

    var group: String {
        return "/v1/userRelation"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        get {
            switch self {
            case .followersList(let lastUserId): return ["userId": lastUserId]
            case .fansList(let lastUserId): return ["userId": lastUserId]
            case .tapFollow(let id): return ["followUserId": id]
            }
        }
        set {}
    }
}


