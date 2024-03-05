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
        InfoRequestView(title: "选择性别", subline: "一旦选择，无法更改。请提供真实信息。", btnEnable: vm.sex != 0) {
            VStack(alignment: .center, spacing: 12) {
                XMDesgin.SelectionTable(text: "男", selected: vm.sex == 1) {
                    vm.sex = 1
                }
                XMDesgin.SelectionTable(text: "女", selected: vm.sex == 2) {
                    vm.sex = 2
                }
            }
        } btnAction: {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(sex: vm.sex))
            if result.is2000Ok {
                vm.presentedSteps.append(.relationhope)
            }
        }
    }
}

#Preview {
    SexRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
