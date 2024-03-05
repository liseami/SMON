//
//  SmokeRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct SmokeRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "您抽烟吗？", subline: "", icon: "inforequest_smoke", btnEnable: true) {
            VStack(alignment: .center, spacing: 12) {
                XMDesgin.SelectionTable(text: "经常", selected: vm.sex == 0) {
                    vm.sex = 0
                }
                XMDesgin.SelectionTable(text: "偶尔", selected: vm.sex == 1) {
                    vm.sex = 1
                }
                XMDesgin.SelectionTable(text: "从不", selected: vm.sex == 1) {
                    vm.sex = 1
                }
                XMDesgin.SelectionTable(text: "仅在社交场合", selected: vm.sex == 1) {
                    vm.sex = 1
                }
            }
        } btnAction: {
            vm.presentedSteps.append(.bio)
        }
        .canSkip {
            vm.presentedSteps.append(.bio)
        }
    }
}

#Preview {
    SmokeRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
