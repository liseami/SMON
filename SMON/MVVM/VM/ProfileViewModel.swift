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
        super.init(target: PostAPI.user(page: 1, userId: userId))
        self.userId = userId
        Task {
            await getData()
        }
    }

    /*
     获取主页数据
     */
    func getData() async {
        await getUserInfo()
        await getPhotos()
        await getListData()
    }

    var isLocalUser: Bool {
        userId == UserManager.shared.user.userId
    }

    enum ProfileBarItem: CaseIterable {
        case media
//        case rank
        case collect
        case gift
        
        var info: LabelInfo {
            switch self {
            case .media:
                return .init(name: "照片与动态", icon: "", subline: "")
            case .collect:
                return .init(name: "收藏", icon: "", subline: "")
//            case .post:
//                return .init(name: "动态", icon: "", subline: "")
//            case .rank:
//                return .init(name: "大赛排名", icon: "", subline: "")
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
            print(user)
            print("")
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
    @MainActor
    func tapChat() async {
        let t = UserOperationAPI.sayHello(toUserId: userId)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            MainViewModel.shared.pushTo(MainViewModel.PagePath.chat(userId: "m" + userId))
        }
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
    
    /*
     喜欢某人
     */
    @MainActor
    func tapLikeMe() async{
        let t = UserOperationAPI.tapUserLike(likeUserId: userId)
        let r = await Networking.request_async(t)
        if r.is2000Ok{
            await getUserInfo()
        }
    }
    
    
}
