//
//  HobbyRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct HobbyRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        InfoRequestView(title: "兴趣爱好", subline: "最多选择5样您喜欢的标签。", icon: "inforequest_hobby", btnEnable: true) {
            VStack(alignment: .leading, spacing: 12) {
                Text("自我疗愈")
                    .font(.title2.bold())
                Text("🧠 正念")
                    .font(.body)
                    .foregroundStyle(Color.XMDesgin.f1)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color.XMDesgin.b1))
            }
        } btnAction: {
            vm.presentedSteps.append(.height)
        }
        .canSkip {
            vm.presentedSteps.append(.height)
        }
    }
}

#Preview {
    HobbyRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
