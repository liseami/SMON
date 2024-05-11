//
//  Notification.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/5/11.
//

import SwiftUI

struct XMNotification: Convertible, Identifiable {
    var id: String = "" // ": 1780522214303596544,
    var userId: String = "" // ": 1764610746026688512,
    var avatar: String = "" // ": "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/avatar/default.jpg",
    var nickname: String = "" // ": "zhanglu1385",
    var title: String = "" // ": "每日大赛：zhanglu1385",
    var subTitle: String = "" // ": "点赞了你的大赛帖子",
    var createdAtStr: String = "" // ": "周三 17:02"
    var extraJson: DSF = .init()
}

struct DSF: Convertible {
    var addFlames: String = "" // ": 30,
    var postContent: String = "" // ": "2012年，波多野结衣出席第九届上海国际成人展开幕和第二届台湾成人博览会",
    var postId: String = "" // ": 2,
    var themeId: String = "" // ": 1
}
