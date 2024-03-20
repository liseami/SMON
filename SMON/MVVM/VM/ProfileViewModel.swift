//
//  HomeViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation

class ProfileViewModel: XMListViewModel<XMPost> {
    @Published var currentTab: ProfileBarItem = .media
    @Published var user: XMUserProfile = .init()
    @Published var photos: [XMPhoto] = []
    var userId: String = ""

    init(userId: String) {
        super.init(pageName: "") { _ in
            PostAPI.themeList(p: .init(page: 1, pageSize: 10, type: 1, themeId: 2))
        }
        self.userId = userId
        print(userId)
        print(userId)
        Task {
            await self.getUserInfo()
            await self.getPhotos()
        }
    }

    var isLocalUser: Bool {
        userId == UserManager.shared.user.userId
    }

    enum ProfileBarItem: CaseIterable {
        case media
//        case post
        case rank
        case gift
        var info: LabelInfo {
            switch self {
            case .media:
                return .init(name: "照片与动态", icon: "", subline: "")
//            case .post:
//                return .init(name: "动态", icon: "", subline: "")
            case .rank:
                return .init(name: "历史排名", icon: "", subline: "")
            case .gift:
                return .init(name: "礼物", icon: "", subline: "")
            }
        }
    }

    @MainActor
    func getUserInfo() async {
        let target = UserAPI.getUserInfo(id: userId)
        let result = await Networking.request_async(target)
        if result.is2000Ok, let userinfo = result.mapObject(XMUserProfile.self) {
            user = userinfo
        }
    }

    @MainActor
    func getPhotos() async {
        let target = UserAPI.albumList(id: userId)
        let result = await Networking.request_async(target)
        if result.is2000Ok, let photos = result.mapArray(XMPhoto.self) {
            self.photos = photos
        }
    }

    /*
     私信
     */

    func tapChat() {
        MainViewModel.shared.pathPages.append(MainViewModel.PagePath.chat(userId: "m" + userId))
    }

    /*
     关注点击
     */
    @MainActor
    func tapFollow() async {
        let t = UserRelationAPI.tapFollow(followUserId: userId)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            await getUserInfo()
        }
    }
}
