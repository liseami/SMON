//
//  PostsOperationAPI.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import Foundation

enum PostsOperationAPI: XMTargetType {
    case themeList(page: Int, sex: Int)
    case tapLike(postId: String)
    case comment(p: CommentReqMod)
    case commentDelete(commentId: String)
    case tapCommentLike(commentId: String)
    case commentList(page: Int, postId: String)
    case commentReplyList(page: Int, commentId: String)

    var group: String {
        return "/v1/postsOperation"
    }

    var parameters: [String: Any]? {
        switch self {
        case .themeList(let page, let sex): return ["page": page, "sex": sex, "pageSize": "50"]
        case .tapLike(let postId): return ["postId": postId]
        case .comment(let p): return p.kj.JSONObject()
        case .commentDelete(let commentId): return ["commentId": commentId]
        case .tapCommentLike(let commentId): return ["commentId": commentId]
        case .commentList(let page, let postId): return ["page": page, "postId": postId]
        case .commentReplyList(let page, let postId): return ["page": page, "commentId": postId, "pageSize": "50"]
        }
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }
}

extension PostsOperationAPI {
    struct CommentReqMod: Convertible {
        /// 回复评论ID
        var commentId: String?
        /// 评论内容
        var content: String?
        /// 图片评论
        var imagePath: String?
        /// 服务端使用
        var ipAddress: String?
        /// 帖子ID
        var postId: String?
        /// 回复评论用户ID
        var toUserId: String?
        /// 评论用户ID，服务端使用
        var userId: Int?
    }
}
