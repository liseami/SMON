//
//  BrithdayDayRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct BrithdayDayRequestView: View {
    @EnvironmentObject var vm : UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "您的生日是？", subline: "", btnEnable: true) {
            DatePicker("", selection: $vm.brithday,displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
        } btnAction: {
            vm.presentedSteps.append(.sex)
        }

    }
}

#Preview {
    BrithdayDayRequestView()
        .environmentObject(UserInfoRequestViewModel())
}