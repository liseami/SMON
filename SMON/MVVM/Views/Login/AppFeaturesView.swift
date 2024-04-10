//
//  AppFeaturesView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct AppFeaturesView: View {
    @EnvironmentObject var vm: LoginViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer()
            XMTyperText(text: "关心另一种趣味\n始于大赛，止于大赛")
                .lineSpacing(6)
                .font(.XMFont.big1.bold())
            Text("「每日大赛官方版」是一款「以图会友」的社交软件，服务于充满展示欲的新新人类。人类的每一种奇思妙想都应该被尊重。始于大赛，止于大赛。")
                .font(.XMFont.f1)
            XMDesgin.CircleBtn(backColor: Color(hex: "1F1F1F"), fColor: .white, iconName: "system_down") {
                vm.pageProgress = .Warning
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.all, 16)
    }
}

#Preview {
    AppFeaturesView()
        .environmentObject(LoginViewModel())
}
