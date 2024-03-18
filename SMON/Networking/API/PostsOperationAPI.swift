//
//  PostsOperationAPI.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import Foundation

enum PostsOperationAPI: XMTargetType {
    case themeList(p: PageInfo)

    var group: String {
        return "/v1/postsOperation"
    }

    var parameters: [String: Any]? {
        get {
            switch self {
            case .themeList(let p): return p.kj.JSONObject()
            default: return nil
            }
        }
       
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }
}

extension PostAPI {}
