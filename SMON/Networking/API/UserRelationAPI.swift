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
    case friendList(page: Int)
    case blackList(page: Int)
    case tapBlack(blackUserId: String)

    var group: String {
        return "/v1/userRelation"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    func updatingParameters(_ newPage: Int) -> any XMTargetType {
        switch self {
        case .followersList: return UserRelationAPI.followersList(page: newPage)
        case .friendList: return UserRelationAPI.friendList(page: newPage)
        case .fansList: return UserRelationAPI.fansList(page: newPage)
        case .blackList: return UserRelationAPI.blackList(page: newPage)
        default: return self
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .tapBlack(let id): return ["blackUserId": id]
        case .followersList(let page): return ["page": page, "pageSize": 20]
        case .fansList(let page): return ["page": page, "pageSize": 20]
        case .tapFollow(let id): return ["followUserId": id]
        case .friendList(let page): return ["page": page, "pageSize": 20]
        case .blackList(let page): return ["page": page, "pageSize": 20]
        }
    }
}
