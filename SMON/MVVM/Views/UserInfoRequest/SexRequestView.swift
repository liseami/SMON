//
//  SexRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct SexRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "选择性别", subline: "一旦选择，无法更改。请提供真实信息。", btnEnable: true) {
            VStack(alignment: .center, spacing: 12) {
                XMDesgin.SelectionTable(text: "男", selected: vm.gender == 0) {
                    vm.gender = 0
                }
                XMDesgin.SelectionTable(text: "女", selected: vm.gender == 1) {
                    vm.gender = 1
                }
            }
        } btnAction: {
            vm.presentedSteps.append(.relationhope)
        }
    }
}

#Preview {
    SexRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
