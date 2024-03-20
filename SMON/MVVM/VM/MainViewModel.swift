//
//  MainViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

import Foundation

class MainViewModel: ObservableObject {
    static let shared: MainViewModel = .init()

    init(currentTabbar: TabbarItem = .home) {
        self.currentTabbar = currentTabbar
        self.pathPages = .init()
    }

    @Published var currentTabbar: TabbarItem = .home
    @Published var pathPages: NavigationPath = .init()

    @MainActor
    func reset() {
        self.currentTabbar = .home
        self.pathPages = .init()
    }

    enum TabbarItem: CaseIterable {
        case home
        case feed
        case message
        case profile

        var labelInfo: LabelInfo {
            switch self {
            case .home:
                return .init(name: "大赛", icon: "tabbar_home", subline: "")
            case .profile:
                return .init(name: "排名", icon: "tabbar_profile", subline: "")
            case .feed:
                return .init(name: "推文", icon: "tabbar_feed", subline: "")
            case .message:
                return .init(name: "消息", icon: "tabbar_message", subline: "")
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

    enum PagePath: Hashable,Decodable {
        case setting
        case notification
        case myhotinfo
        case myfriends
        case profileEditView
        case postdetail(postId: Int)
        case profile(userId: String)
        case chat(userId:String)
    }
}
