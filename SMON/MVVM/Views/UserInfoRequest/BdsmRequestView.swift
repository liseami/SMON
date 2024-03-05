//
//  BdsmRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

enum SexualRole: Int, CaseIterable {
    case dom = 1
    case sado = 2
    case sub = 3
    case masp = 4
    case undecided = 0

    var description: String {
        switch self {
        case .dom:
            return "DOM"
        case .sado:
            return "Sado"
        case .sub:
            return "SUB"
        case .masp:
            return "Masp"
        case .undecided:
            return "我还不确定"
        }
    }
}

struct BdsmRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "您的自我身份认同？", subline: "", icon: "inforequest_bdsm", btnEnable: vm.bdsmAttr < 5) {
            VStack(alignment: .center, spacing: 12) {
                ForEach(SexualRole.allCases, id: \.self) { role in
                    XMDesgin.SelectionTable(text: role.description, selected: vm.bdsmAttr == role.rawValue) {
                        vm.bdsmAttr = role.rawValue
                    }
                }
            }
        } btnAction: {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(bdsmAttr: vm.bdsmAttr))
            if result.is2000Ok {
                vm.presentedSteps.append(.wechat)
            }
        }
    }
}

#Preview {
    BdsmRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
