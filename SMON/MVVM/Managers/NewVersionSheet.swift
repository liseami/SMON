//
//  NewVersionSheet.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/5/10.
//

import SwiftUI

struct NewVersionSheet: View {
    let versionInfo : XMVersionInfo
    init(versionInfo: XMVersionInfo) {
        self.versionInfo = versionInfo
    }
    var body: some View {
        VStack(spacing: 12) {
            Text("每日大赛新版本！")
                .font(.XMFont.big3.bold())
            XMLoginVideo()
                .ignoresSafeArea()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(height: 120)
            Text(versionInfo.versionDesc)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.all, 12)
                .addBack()
            Spacer()
            XMDesgin.XMMainBtn(fColor: .XMColor.b1, backColor: .XMColor.f1, iconName: "", text: "去AppStore更新到最新版本", enable: true) {
                guard let writeReviewURL = URL(string: AppConfig.AppStoreURL.absoluteString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(writeReviewURL) {
                    UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                } else {
                    // 在这里处理无法打开App Store的情况
                }
            }
        }.padding(.all, 24)
            .padding(.top, 24)
    }
}

#Preview {
    NewVersionSheet.init(versionInfo:
            .init()
    
    
    )
}
