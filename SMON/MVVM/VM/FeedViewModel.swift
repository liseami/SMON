//
//  FeedViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var postDetail: XMPost?
    @Published var currentTopTab: FeedTopBarItem = .competition

    enum FeedTopBarItem: CaseIterable {
        case near
        case localCity
        case competition
        case hot
        case flow
        var info: LabelInfo {
            switch self {
            case .competition:
                return .init(name: "每日大赛", icon: "", subline: "")
            case .localCity:
                return .init(name: "苏州", icon: "", subline: "")
            case .near:
                return .init(name: "附近", icon: "", subline: "")
            case .hot:
                return .init(name: "推荐", icon: "", subline: "")
            case .flow:
                return .init(name: "关注", icon: "", subline: "")
            }
        }
    }
}
