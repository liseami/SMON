//
//  Post.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import Foundation

struct XMPost: Convertible, Identifiable {
    
    var id: String = ""
    var userId: String = ""
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
    var isCollect: Int = 0
}

struct XMPostComment: Convertible, Equatable, Identifiable {
    var id: String = "" ////
    var userId: String = "" // 1764610746026688512,
    var nickname: String = "" // "zhanglu1385",
    var avatar: String = "" // "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/avatar/default.jpg",
    var isLiked: Int = 0 //
    var isPostsAuthor: Int = 0 //
    var likeNum: Int = 0 //
    var commentNum: Int?//
    var content: String = "" // "这是一级评论",
    var imagePath: String = "" // "",
    var createdAt: Int = 0 // 1710813905,
    var createdAtStr: String = "" // "周二 10:05"
}


struct XMPostReply: Convertible, Equatable, Identifiable {
    var id: String = "" // : 2,
    var userId: String = "" // ": 1764610746026688512,
    var nickname: String = "" // ": "zhanglu1385",
    var avatar: String = "" // ": "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/avatar/default.jpg",
    var toUserId: String = "" // ": 1764610746026688512,
    var toUserNickname: String = "" // ": "zhanglu1385",
    var toUserAvatar: String = "" // ": "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/avatar/default.jpg",
    var isLiked: Int = 0 // ": 0,
    var isPostsAuthor: Int = 0 // ": 1,
    var likeNum: Int = 0 // ": 0,
    var content: String = "" // ": "回复评论",
    var imagePath: String = "" // ": "",
    var createdAt: String = "" // ": 1710819287,
    var createdAtStr: String = "" // ": "周二 11:34"
}

struct XMPostDetail: Convertible {
    var id: String = "" //// "" // 2,
    var userId: String = "" // 1764610746026688512,
    var nickname: String = "" // "zhanglu1385",
    var avatar: String = "" // "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/avatar/default.jpg",
    var postContent: String = "" // "2012年，波多野结衣出席第九届上海国际成人展开幕和第二届台湾成人博览会",
    var attachNums: Int = 0 // = "" // 0,
    var postAttachs: [PostAttachment] = [] // [],
    var likeNums: Int = 0 // = "" // 1,
    var commentNums: Int = 0 // "" // 0,
    var isLiked: Int = 0
    var createdAt: String = "" // 1710319327,
    var createdAtStr: String = "" // "昨天 16:42"
}

struct PostAttachment: Convertible {
    var picUrl: String = ""
    var picPath: String = ""
    var id: String = ""
}
