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

struct XMPostDetail: Convertible {
    var id: Int = 0 // "" // 2,
    var userId: Int = 0 // 1764610746026688512,
    var nickname: String = "" // "zhanglu1385",
    var avatar: String = "" // "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/avatar/default.jpg",
    var postContent: String = "" // "2012年，波多野结衣出席第九届上海国际成人展开幕和第二届台湾成人博览会",
    var attachNums: Int = 0 // = "" // 0,
    var postAttachs: [PostAttachment] = []  // [],
    var likeNums: Int = 0 // = "" // 1,
    var commentNums: Int = 0 // "" // 0,
    var isLiked: Int = 0
    var createdAt: String = "" // 1710319327,
    var createdAtStr: String = "" // "昨天 16:42"
}

struct PostAttachment: Convertible {
    var picUrl: String = ""
    var picPath: String = ""
    var id: Int = 0
}
