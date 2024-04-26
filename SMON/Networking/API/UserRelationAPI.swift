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
    case blackAllList
    case contactSettingView(contactType: String)
    case updateUserContact(contactType: String, contactValue: String, threshold: String)
    case unlock(page: Int)
    case unlocked(page: Int)
    case unlockContactInfo(toUserId: String)
    case wechatCopy(id: String)
    

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
        case .unlocked: return UserRelationAPI.unlocked(page: newPage)
        case .unlock: return UserRelationAPI.unlock(page: newPage)
        case .followersList: return UserRelationAPI.followersList(page: newPage)
        case .friendList: return UserRelationAPI.friendList(page: newPage)
        case .fansList: return UserRelationAPI.fansList(page: newPage)
        case .blackList: return UserRelationAPI.blackList(page: newPage)
        default: return self
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .wechatCopy(let id): return ["id": id]
        case .unlockContactInfo(let toUserId): return ["toUserId": toUserId]
        case .unlock(let page): return ["page": page, "pageSize": 20]
        case .unlocked(let page): return ["page": page, "pageSize": 20]
        case .contactSettingView(let contactType): return ["contactType": contactType]
        case .updateUserContact(let contactType, let contactValue, let threshold): return ["contactType": contactType, "contactValue": contactValue, "threshold": threshold]
        case .blackAllList: return nil
        case .tapBlack(let id): return ["blackUserId": id]
        case .followersList(let page): return ["page": page, "pageSize": 20]
        case .fansList(let page): return ["page": page, "pageSize": 20]
        case .tapFollow(let id): return ["followUserId": id]
        case .friendList(let page): return ["page": page, "pageSize": 20]
        case .blackList(let page): return ["page": page, "pageSize": 20]
        
        }
    }
}
