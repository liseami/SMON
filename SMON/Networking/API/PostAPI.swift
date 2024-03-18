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
    var group: String {
        return "/v1/posts"
    }

    var parameters: [String: Any]? {
        get {
            switch self {
            case .publish(let p): return p.kj.JSONObject()
            case .themeList(let p): return p.kj.JSONObject()
            default: return nil
            }
        }
        set {}
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
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
        var pageSize: Int = 10
        // 1 最热，2最新
        var type: Int = 1
        var themeId: Int = 0
    }
}
