//
//  MainViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

import Foundation
import ImSDK_Plus

class MainViewModel: ObservableObject {
    static let shared: MainViewModel = .init()

    init(currentTabbar: TabbarItem = .home) {
        self.currentTabbar = currentTabbar
        self.pathPages = .init()
        self.getUnreadCount()
    }

    @Published var currentTabbar: TabbarItem = .home
    @Published var homeBtnJump: Int = 0
    @Published var pathPages: NavigationPath = .init()
    @Published var unreadCount: Int = 0
    /*
     获取会话总未读数
     */
    func getUnreadCount() {
        V2TIMManager.sharedInstance().getUnreadMessageCount(by: .init(), succ: { count in
            DispatchQueue.main.async {
                self.unreadCount = Int(count)
            }
        }, fail: { _, _ in

        })
    }

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
//                return .init(name: "", icon: "tabbar_circle_post", subline: "")
                return .init(name: "冲榜", icon: "tabbar_circle_rank", subline: "")
            case .feed, .message, .profile:
                return .init(name: "", icon: "tabbar_circle_post", subline: "")
            }
        }
    }

    func pushTo(_ type: any Hashable) {
        self.pathPages.append(type)
    }

    func pageBack() {
        self.pathPages.removeLast()
    }

    func removeAllPage() {
        self.pathPages = .init()
    }

    enum PagePath: Hashable, Decodable {
        case mygift
        case mybill
        case setting
        case notification
        case myhotinfo
        case myfriends
        case profileEditView
        case postdetail(postId: String)
        case profile(userId: String)
        case chat(userId: String)
        case flamedetail
        case myCoinView
    }
}
