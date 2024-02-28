//
//  NameRequestView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

struct NameRequestView: View {
    @EnvironmentObject var vm: UserInfoRequestViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            VStack(alignment: .leading, spacing: 12, content: {
                Text("向会员们介绍你自己")
                    .multilineTextAlignment(.leading)
                    .bold()
                Text("昵称日后也可以修改。")
                    .font(.body).foregroundStyle(Color.XMDesgin.f2)
            })

            VStack(alignment: .leading, spacing: 12, content: {
                Text("昵称")
                    .font(.caption)
                    .foregroundStyle(Color.XMDesgin.f3)
                TextField("请输入昵称", text: $vm.name)
                    .autoOpenKeyboard()
                    .foregroundStyle(Color.XMDesgin.f1)
                    .tint(Color.XMDesgin.main)
                Capsule()
                    .frame(height: 1)
                    .foregroundColor(Color.XMDesgin.f3)
            })

            Spacer()
            XMDesgin.CircleBtn(backColor: Color.XMDesgin.f1, fColor: Color.XMDesgin.b1, iconName: "system_down") {
//                vm.presentedSteps.append(.photo)
            }
            .rotationEffect(.degrees(-90))
            .isShakeBtn(enable: true, action: {})
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .statusBarHidden(false)
        .padding(.all)
        .font(.title)
        .padding(.top, 40)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NameRequestView()
        .environmentObject(UserInfoRequestViewModel())
}
