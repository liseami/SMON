//
//  WarningView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct AppWarningView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("我们需要知道这个App是否适合为您服务")
                .bold()
                .font(.title)

            HStack {
                Image(systemName: "circle")
                Text("我不会将App分享给对小众文化不了解的「圈外人」。")
            }
            HStack {
                Image(systemName: "circle")
                Text("我不会将App中的「用户内容」分享到广域社交网络中。")
            }
            HStack {
                Image(systemName: "circle")
                Text("我对「亚文化」没有歧视，始终保持着友好、阳光、乐观的态度来对待陌生人。")
            }
            HStack {
                Image(systemName: "circle")
                Text("我同意「每日大赛」的《用户协议》与《隐私政策》。")
            }
            NavigationLink {
                LoginView_PhoneNumber()
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
    }
}

#Preview {
    AppWarningView()
}
