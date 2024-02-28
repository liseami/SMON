//
//  RelationHopeRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct RelationHopeRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "你想寻找什么样的\r情感关系？", subline: "真诚的选择，有助于您和「每日大赛 - 西檬」中的所有用户找到自己真正想要的。", btnEnable: true) {
            VStack(alignment: .center, spacing: 12) {
                XMDesgin.SelectionTable(text: "长期关系", selected: vm.relationHope == 0) {
                    vm.relationHope = 0
                }
                XMDesgin.SelectionTable(text: "自由无束缚的关系", selected: vm.relationHope == 1) {
                    vm.relationHope = 1
                }
                XMDesgin.SelectionTable(text: "我还不确定", selected: vm.relationHope == 2) {
                    vm.relationHope = 2
                }
            }
        } btnAction: {
            vm.presentedSteps.append(.hobby)
        }
    }
}

#Preview {
    RelationHopeRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
