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
            Picker("Height", selection: .constant(110)) {
                ForEach(110 ..< 271) { height in
                    Text("\(height) cm")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .padding(.all)
            .background(Color.XMDesgin.b1)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        } btnAction: {
            vm.presentedSteps.append(.bdsm)
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
