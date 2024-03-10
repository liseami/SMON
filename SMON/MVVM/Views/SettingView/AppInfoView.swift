//
//  AppInfoView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/10.
//

import SwiftUI

struct AppInfoView: View {
    var versionInfo: String {
        "Version" + " " + AppConfig.AppVersion
    }

    var build: String {
        var b = AppConfig.AppVersion.md5()
        return "(\(String(b!.slice(from: 0, to: 7))))"
    }

    @State var showLogo : Bool = false
    var body: some View {
        VStack(spacing: 16) {
            XMAppLogo()
                .transition(.movingParts.anvil.animation(.spring))
                .ifshow(show: showLogo)
            VStack(spacing: 6) {
                Text("每日大赛 - 西檬")
                    .font(.XMFont.f1b)
                XMTyperText(text: versionInfo + " " + build)
                    .font(.XMFont.f2)
            }
            .onAppear(perform: {
                showLogo = true
            })
            .padding(.bottom, 120)
            XMDesgin.XMListRow(.init(name: "用户协议", icon: "setting_userbook", subline: ""), showRightArrow: true) {
                Apphelper.shared.presentPanSheet(InAppBrowser(url: AppConfig.UserPrivacyPolicy)
                    .preferredColorScheme(.dark), style: .cloud)
            }
            XMDesgin.XMListRow(.init(name: "隐私政策", icon: "setting_userbook", subline: ""), showRightArrow: true) {
                Apphelper.shared.presentPanSheet(InAppBrowser(url: AppConfig.UserPrivacyPolicy)
                    .preferredColorScheme(.dark), style: .cloud)
            }
            Spacer()
        }
        .padding(.horizontal,32)
        .padding(.vertical, 66)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppInfoView()
}
