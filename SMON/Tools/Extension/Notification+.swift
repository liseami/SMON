//
//  Notification+.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/25.
//

import Foundation

public extension Notification.Name {
    static let PostTapLike =
        Notification.Name("com.wuhanjiyunshang.meiridasai.POST_TAP_LIKE")
    static let APP_GO_TO_ACTIVE =
        Notification.Name("com.wuhanjiyunshang.meiridasai.APP_GO_TO_ACTIVE")
    static let POST_PUBLISHED_SUCCESS =
        Notification.Name("com.wuhanjiyunshang.meiridasai.POST_PUBLISHED_SUCCESS")
    static let IAP_BUY_SUCCESS =
        Notification.Name("com.wuhanjiyunshang.meiridasai.IAP_BUY_SUCCESS")
    static let ADD_NEW_COMMENT_SUCCESS =
        Notification.Name("com.wuhanjiyunshang.meiridasai.ADD_NEW_COMMENT_SUCCESS")
    static let ADD_NEW_REPLEY_SUCCESS =
        Notification.Name("com.wuhanjiyunshang.meiridasai.ADD_NEW_REPLEY_SUCCESS")
}
