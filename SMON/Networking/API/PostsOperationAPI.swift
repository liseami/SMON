//
//  PostsOperationAPI.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import Foundation

enum PostsOperationAPI: XMTargetType {
    case themeList(p: PageInfo)
    case tapLike(postId: Int)
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
        case .themeList(let p): return p.kj.JSONObject()
        case .tapLike(let postId): return ["postId": postId]
        case .comment(let p): return p.kj.JSONObject()
        case .commentDelete(let commentId): return ["commentId": commentId]
        case .tapCommentLike(let commentId): return ["commentId": commentId]
        case .commentList(let page, let postId): return ["page": page, "postId": postId]
        case .commentReplyList(let page, let postId): return ["page": page, "postId": postId]
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
        var commentId: Int?
        /// 评论内容
        var content: String?
        /// 图片评论
        var imagePath: String?
        /// 服务端使用
        var ipAddress: String?
        /// 帖子ID
        var postId: Int?
        /// 回复评论用户ID
        var toUserId: Int?
        /// 评论用户ID，服务端使用
        var userId: Int?
    }
}
