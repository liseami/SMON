//
//  HomeViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var currentTab: ProfileBarItem = .media
    @Published var user: XMUserProfile = .init()
    @Published var photos: [XMPhoto] = []
    var userId: String = ""

    init(userId: String) {
        self.userId = userId
        Task {
            await self.getUserInfo()
            await self.getPhotos()
        }
    }

    var isLocalUser: Bool {
        userId == UserManager.shared.user.userId.string
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

    func tapChat() async {}
}
