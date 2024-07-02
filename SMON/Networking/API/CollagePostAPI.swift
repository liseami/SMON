//
//  CollagePostAPI.swift
//  SMON
//
//  Created by mac xiao on 2024/6/26.
//

import Foundation
enum CollagePostAPI: XMTargetType {
    case tapCollect(postId: String)
    case list(page: Int, userId: String)

    var group: String {
        return "/v2/postsCollect"
    }

    var parameters: [String: Any]? {
        switch self {
        case .list(let page, let userId): return ["page": page, "pageSize": "20", "userId": userId]
        case .tapCollect(let postId): return ["postId": postId]
        }
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    func updatingParameters(_ newPage: Int) -> XMTargetType {
        switch self {
            
        case .tapCollect(let postId): return CollagePostAPI.tapCollect(postId: postId)
        case .list(let page, let userId): return CollagePostAPI.list(page: page, userId: userId)
            
        
        default: return self
        }
    }
}
