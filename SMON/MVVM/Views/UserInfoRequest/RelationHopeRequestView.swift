//
//  RelationHopeRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

enum EmotionalNeed: Int, CaseIterable {
    case longTermRelationship = 1
    case freeRelationship = 2
    case undecided = 0

    var description: String {
        switch self {
        case .longTermRelationship:
            return "长期关系"
        case .freeRelationship:
            return "自由无束缚的关系"
        case .undecided:
            return "我还不确定"
        }
    }
}

struct RelationHopeRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "你想寻找什么样的\r情感关系？", subline: "真诚的选择，有助于您和「每日大赛 - 西檬」中的所有用户找到自己真正想要的。", btnEnable: vm.emotionalNeeds < 3) {
            VStack(alignment: .center, spacing: 12) {
                ForEach(EmotionalNeed.allCases, id: \.self) { need in
                    XMDesgin.SelectionTable(text: need.description, selected: vm.emotionalNeeds == need.rawValue) {
                        vm.emotionalNeeds = need.rawValue
                    }
                }
            }
        } btnAction: {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(emotionalNeeds: vm.emotionalNeeds))
            if result.is2000Ok {
                vm.presentedSteps.append(.hobby)
            }
        }
    }
}

#Preview {
    RelationHopeRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
