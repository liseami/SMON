//
//  Post.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import Foundation

struct XMPost: Convertible {
    var id: Int = 0
    var userId: Int = 0
    var nickname: String = ""
    var avatar: String = ""
    var postContent: String = ""
    var attachNums: Int = 0
    var postAttachs: [PostAttachment] = []
    var likeNums: Int = 0
    var commentNums: Int = 0
    var isLiked: Int = 0
    var createdAt: Int = 0
    var createdAtStr: String = ""
}

struct PostAttachment: Convertible {
    var picUrl: String = ""
    var picPath: String = ""
    var id: Int = 0
}
