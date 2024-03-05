//
//  HomeViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var currentTab: ProfileBarItem = .media

    var userId : String = ""
    init( userId: String) {
        self.userId = userId
    }
    var isLocalUser : Bool {
        userId == UserManager.shared.user.userId
    }
    enum ProfileBarItem: CaseIterable {
        case media
        case post
        case rank
        case gift
        var info: LabelInfo {
            switch self {
            case .media:
                return .init(name: "照片", icon: "", subline: "")
            case .post:
                return .init(name: "动态", icon: "", subline: "")
            case .rank:
                return .init(name: "历史排名", icon: "", subline: "")
            case .gift:
                return .init(name: "礼物", icon: "", subline: "")
            }
        }
    }
}
