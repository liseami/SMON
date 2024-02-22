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
        VStack(spacing: 12) {
            Spacer()
            Text("关心另一种癖好，查看另一个世界的新鲜事")
                .bold()
                .font(.title)
            Text("西檬「每日大赛」是一款美味、暗黑风、灵敏的社交软件，服务于那些「拥有小小怪癖」的人类。人的每一种奇思妙想都应该被尊重，无论是幻想还是现实，我们都会为你提供一个安全可靠的社交空间。")
            Image(systemName: "arrow.down.circle.fill")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    vm.pageProgress = .Warning
                }
        }
        .padding()
    }
}

#Preview {
    AppFeaturesView()
        .environmentObject(LoginViewModel())
}
