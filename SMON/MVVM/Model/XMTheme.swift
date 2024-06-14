//
//  XMCom.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import Foundation

struct XMTheme: Identifiable, Convertible,Equatable {
    var id: Int = 0 // 1,
    var sex: Int = 0 // 2,
    var title: String = "" // "包臀裙大赛",
    var coverUrl: String = "" // "https://dailycontest.oss-cn-shanghai.aliyuncs.com/posts/theme/test.jpg",
    var description: String = "" // "这是一个包臀裙大赛",
    var startAt: Int = 0 // 1710259200,
    var endAt: Int = 0 // 1710345600,
    var postsNums: Int = 0 // 1,
    var postsNumsStr: Int = 0 // "1"
}

extension XMTheme {
    var deadlineInfoStr: String {
        return "\(abs(self.endAt.daysUntilDeadline))天\(self.endAt.daysUntilDeadline > 0 ? "后" : "前")截止"
    }
}
