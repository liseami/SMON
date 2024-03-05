//
//  HeightRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct HeightRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "您的身高是？", subline: "一旦选择，无法更改，请提供有效信息。", icon: "inforequest_ruler", btnEnable: true) {
            Picker("Height", selection: $vm.height) {
                ForEach(130 ..< 240) { height in
                    Text("\(height) cm").tag(height)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .padding(.all)
            .background(Color.XMDesgin.b1)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        } btnAction: {
            let result = await UserManager.shared.updateUserInfo(updateReqMod: .init(height: vm.height))
            if result.is2000Ok {
                vm.presentedSteps.append(.bdsm)
            }
        }
        .canSkip {
            vm.presentedSteps.append(.bdsm)
        }
    }
}

#Preview {
    HeightRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
