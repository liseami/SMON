//
//  HomeViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/25.
//

import Foundation

struct FliterModInput {
    init(mod: FliterMod) {
        self.range = mod.range.double
        self.sex = mod.sex
        self.maxAgeProgress = Double(mod.maxAge - 18) / 22 * 100
        self.minAgeProgress = Double(mod.minAge - 18) / 22 * 100
    }

    var maxAge: Int {
        Int(maxAgeProgress / 100 * 22) + 18
    }

    var minAge: Int {
        Int(minAgeProgress / 100 * 22) + 18
    }

    var maxAgeProgress: Double = 100
    var minAgeProgress: Double = 0
    var range: Double = 200
    var sex: Int?
}

struct FliterMod: Convertible {
    var maxAge: Int = 40
    var minAge: Int = 18
    var range: Int = 200
    var sex: Int?
}

class RankViewModel: ObservableObject {
    @Published var currentTopTab: HomeTopBarItem = .all

    func target(for tab: HomeTopBarItem) -> RankAPI {
        switch tab {
        case .near:
            return .nearby(page: 1, fliter: .init())
        case .localCity:
            return RankAPI.sameCity(cityId: UserManager.shared.user.cityId.int ?? 0, page: 1)
        case .all:
            return RankAPI.country(page: 1)
        case .likeme:
            return RankAPI.LikeMe(page: 1)
//            return RankAPI.fans(page: 1)
        case .vistor:
            return RankAPI.visitor(page: 1)
        }
    }

    enum HomeTopBarItem: CaseIterable {
        case near
        case localCity
        case all
//        case fans
//        case flow
        case likeme
        case vistor
        var info: LabelInfo {
            switch self {
            case .all:
                return .init(name: "全国", icon: "", subline: "")
            case .localCity:
                return .init(name: "苏州", icon: "", subline: "")
            case .near:
                return .init(name: "附近", icon: "", subline: "")
            case .likeme:
                return .init(name: "喜欢我的", icon: "", subline: "")
//            case .fans:
//                return .init(name: "粉丝", icon: "", subline: "")
//            case .flow:
//                return .init(name: "关注", icon: "", subline: "")
            case .vistor:
                return .init(name: "访客", icon: "", subline: "")
            }
        }
    }
}
