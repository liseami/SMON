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
    case followersList(page: Int)
    case fansList(page: Int)

    var group: String {
        return "/v1/userRelation"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .followersList(let page): return ["page": page, "pageSize": 20]
        case .fansList(let page): return ["page": page, "pageSize": 20]
        case .tapFollow(let id): return ["followUserId": id]
        }
    }
}
