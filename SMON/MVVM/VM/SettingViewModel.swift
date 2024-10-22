//
//  SettingViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation

class SettingViewModel: ObservableObject {
    var settingGroup: [SettingItem] =
        [
            .init(name: "获得赛币", children: [
                .init(name: "邀请好友", iconName: "setting_invite"),
                .init(name: "会员方案", iconName: "setting_shop"),
            ]),
            .init(name: "账号与安全", children: [
                .init(name: "实名认证", iconName: "setting_idcard"),
                .init(name: "修改绑定手机", iconName: "setting_phone"),
                .init(name: "黑名单", iconName: "setting_blacklist"),
                .init(name: "通知", iconName: "setting_notification"),
                .init(name: "账户注销", iconName: "setting_sginout"),
            ]),
            .init(name: "关于App", children: [
                .init(name: "App信息", iconName: "setting_about"),
                .init(name: "用户协议", iconName: "setting_userbook"),
                .init(name: "隐私政策", iconName: "setting_userbook"),
                .init(name: "第三方SDK信息共享清单", iconName: "setting_sdk"),
            ]),
        ]
}
