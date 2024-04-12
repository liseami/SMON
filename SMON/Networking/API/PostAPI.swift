//
//  PostAPI.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import Foundation

enum PostAPI: XMTargetType {
    case publish(p: PostPublishReqMod)
    case themeList(p: ThemePostListReqMod)

    case sameCityList(page: Int)
    case recommendList(page: Int)
    case followList(page: Int)
    case nearbyList(page: Int)

    case delete(postId: String, userId: String)
    case detail(postId: String, userId: String)
    case user(page: Int, userId: String)

    var group: String {
        return "/v1/posts"
    }

    var parameters: [String: Any]? {
        switch self {
        case .user(let page, let userId): return ["page": page, "pageSize": "20", "userId": userId]
        case .sameCityList(let page): return ["page": page, "pageSize": "20"]
        case .recommendList(let page): return ["page": page, "pageSize": "20"]
        case .followList(let page): return ["page": page, "pageSize": "20"]
        case .nearbyList(let page): return ["page": page, "pageSize": "20",
                                            "latitude": UserManager.shared.userlocation.lat, "longitude": UserManager.shared.userlocation.long]
        case .publish(let p): return p.kj.JSONObject()
        case .themeList(let p): return p.kj.JSONObject()
        case .delete(let postId, let userId): return ["userId": userId, "postId": postId]
        case .detail(let postId, let userId): return ["userId": userId, "postId": postId]
        }
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    func updatingParameters(_ newPage: Int) -> XMTargetType {
        switch self {
        case .user(let page, let userId): return PostAPI.user(page: newPage, userId: userId)
        case .themeList(let p):
            return PostAPI.themeList(p: .init(page: newPage, pageSize: p.pageSize, type: p.type, themeId: p.themeId))
        case .sameCityList(let p): return PostAPI.sameCityList(page: newPage)
        case .recommendList(let p): return PostAPI.recommendList(page: newPage)
        case .followList(let p): return PostAPI.followList(page: newPage)
        case .nearbyList(let p): return PostAPI.nearbyList(page: newPage)
        default: return self
        }
    }
}

extension PostAPI {
    struct PostPublishReqMod: Convertible {
        var postContent: String = "2"
        var postAttachs: [String] = []
        var themeId: String?
    }

    struct ThemePostListReqMod: Convertible {
        var page: Int = 1
        var pageSize: Int = 20
        // 1 最热，2最新
        var type: Int = 1
        var themeId: Int = 0
    }
}
