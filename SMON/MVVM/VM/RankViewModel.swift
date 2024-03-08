//
//  HomeViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation

class RankViewModel: ObservableObject {
    @Published var currentTopTab: HomeTopBarItem = .all
    
    enum HomeTopBarItem: CaseIterable {
        case near
        case localCity
        case all
        case fans
        case flow
        case vistor
        var info: LabelInfo {
            switch self {
            case .all:
                return .init(name: "全国", icon: "", subline: "")
            case .localCity:
                return .init(name: "苏州", icon: "", subline: "")
            case .near:
                return .init(name: "附近", icon: "", subline: "")
            case .fans:
                return .init(name: "粉丝", icon: "", subline: "")
            case .flow:
                return .init(name: "关注", icon: "", subline: "")
            case .vistor:
                return .init(name: "访客", icon: "", subline: "")
            }
        }
    }
}
