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
    case delete(postId: Int, userId: String)
    case detail(postId: Int, userId: String)

    var group: String {
        return "/v1/posts"
    }

    var parameters: [String: Any]? {
        switch self {
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
        case .themeList(let p):
            return PostAPI.themeList(p: .init(page: newPage, pageSize: p.pageSize, type: p.type, themeId: p.themeId))
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
