//
//  MainViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

import Foundation

class MainViewModel: ObservableObject {
    init(currentTabbar: TabbarItem = .home) {
        self.currentTabbar = currentTabbar
        self.pathPages.removeAll()
    }

    func reset() {
        self.currentTabbar = .home
        self.pathPages.removeAll()
    }

    static let shared: MainViewModel = .init()

    enum TabbarItem: CaseIterable {
        case home
        case feed
        case message
        case profile
        var labelInfo: LabelInfo {
            switch self {
            case .home:
                return .init(name: "大赛", icon: "tabbar_home", subline: "")
            case .feed:
                return .init(name: "推文", icon: "tabbar_feed", subline: "")
            case .message:
                return .init(name: "消息", icon: "tabbar_message", subline: "")
            case .profile:
                return .init(name: "我的", icon: "tabbar_profile", subline: "")
            }
        }

        var circleBtnInfo: LabelInfo {
            switch self {
            case .home:
                return .init(name: "冲榜", icon: "tabbar_circle_rank", subline: "")
            case .feed, .message, .profile:
                return .init(name: "", icon: "tabbar_circle_post", subline: "")
            }
        }
    }

    @Published var currentTabbar: TabbarItem = .home

    @Published var pathPages: [PagePath] = []
    enum PagePath: Hashable {
        case setting
        case notification
        case myprofile
        case coinshop
        case myhotinfo
        case myfriends
        case profileEditView
        case postdetail(postId: String)
    }
}
