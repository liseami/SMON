//
//  BdsmRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct BdsmRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "您的自我身份认同？", subline: "", icon: "inforequest_bdsm", btnEnable: true) {
            VStack(alignment: .center, spacing: 12) {
                XMDesgin.SelectionTable(text: "DOM", selected: vm.gender == 1) {
                    vm.gender = 1
                }
                XMDesgin.SelectionTable(text: "SUB", selected: vm.gender == 1) {
                    vm.gender = 1
                }
                XMDesgin.SelectionTable(text: "S", selected: vm.gender == 0) {
                    vm.gender = 0
                }
                XMDesgin.SelectionTable(text: "M", selected: vm.gender == 1) {
                    vm.gender = 1
                }
            }
        } btnAction: {
            vm.presentedSteps.append(.smoke)
        }
    }
}

#Preview {
    BdsmRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
