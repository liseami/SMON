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
            Text("关心另一种社交趣味，查看小众世界的新鲜事")
                .bold()
                .font(.title)
            Text("西檬「每日大赛」是一款「小众文化」社交软件，服务于那些「拥有小小怪癖」的人类。人类的每一种奇思妙想都应该被尊重。始于西檬，止于西檬。")

            XMDesgin.CircleBtn(backColor: Color.init(hex: "1F1F1F"), fColor: .white, iconName: "system_down") {
                vm.pageProgress = .Warning
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
    }
}

#Preview {
    AppFeaturesView()
        .environmentObject(LoginViewModel())
}
