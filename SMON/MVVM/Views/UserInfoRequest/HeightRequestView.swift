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
        InfoRequestView(title: "您的身高是？", subline: "", icon: "inforequest_ruler", btnEnable: true) {
            Picker("Height", selection: .constant(110)) {
                ForEach(110 ..< 271) { height in
                    Text("\(height) cm")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
        } btnAction: {
            vm.presentedSteps.append(.drink)
        }
        .canSkip {
            vm.presentedSteps.append(.drink)
        }
    }
}

#Preview {
    HeightRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
