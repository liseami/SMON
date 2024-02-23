//
//  MainViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

import Foundation

class MainViewModel: ObservableObject {
    enum TabbarItem: CaseIterable {
        case home
        case feed
        case message
        case profile
        var labelInfo: LabelInfo {
            switch self {
            case .home:
                return .init(name: "大赛", icon: "", subline: "")
            case .feed:
                return .init(name: "推文", icon: "", subline: "")
            case .message:
                return .init(name: "消息", icon: "", subline: "")
            case .profile:
                return .init(name: "我的", icon: "", subline: "")
            }
        }
    }

    @Published var currentTabbar: TabbarItem = .home
}
