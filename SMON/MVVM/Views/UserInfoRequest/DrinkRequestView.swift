//
//  DrinkRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct DrinkRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "您喝酒吗？", subline: "", icon: "inforequest_drink", btnEnable: true) {
            VStack(alignment: .center, spacing: 12) {
                XMDesgin.SelectionTable(text: "经常", selected: vm.gender == 0) {
                    vm.gender = 0
                }
                XMDesgin.SelectionTable(text: "偶尔", selected: vm.gender == 1) {
                    vm.gender = 1
                }
                XMDesgin.SelectionTable(text: "从不", selected: vm.gender == 1) {
                    vm.gender = 1
                }
                XMDesgin.SelectionTable(text: "仅在社交场合", selected: vm.gender == 1) {
                    vm.gender = 1
                }
            }
        } btnAction: {
            vm.presentedSteps.append(.smoke)
        }
        .canSkip {
            vm.presentedSteps.append(.smoke)
        }
    }
}

#Preview {
    DrinkRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
