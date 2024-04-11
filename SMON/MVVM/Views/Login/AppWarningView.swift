//
//  WarningView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct AppWarningView: View {
    @EnvironmentObject var vm: LoginViewModel
    let warnings = ["我对「开放式关系」和「亚文化社交」没有歧视，始终保持着友好、阳光、乐观的态度来对待陌生人。", "我不会将App分享给对小众文化不了解的「圈外人」。",
                    "我不会将App中的「用户内容」分享到广域社交网络中（本App已启用截图防护功能）。"]
    @State var agreeList: [String] = []
    @State var showBtns: Bool = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            title
            rules
            markdown
        }
        .padding()
        .onAppear(perform: {
            withAnimation {
                showBtns = true
            }
        })
    }

    var title: some View {
        XMTyperText(text: "我们需要知道这个App是否适合为您服务")
            .lineSpacing(6)
            .font(.XMFont.big1.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    var markdown: some View {
        HStack {
            Text(LocalizedStringKey("点击下一步，即代表您已阅读并同意[《每日大赛APP用户协议》](https://ismonlove.com/work/YHXY.html) 与 [《每日大赛APP用户隐私政策》](https://ismonlove.com/work/YSZC.html)。"))
                .font(.XMFont.f2)
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
                .fcolor(.XMDesgin.f2)
                .frame(width: 240)
                .tint(Color.XMDesgin.main)
                .environment(\.openURL, OpenURLAction { url in
                    print(url)
                    Apphelper.shared.mada(style: .rigid)
                    Apphelper.shared.presentPanSheet(InAppBrowser(url: url)
                        .preferredColorScheme(.dark), style: .cloud)
                    return .handled
                })
            Spacer()
            XMDesgin.CircleBtn(backColor: Color.white, fColor: Color.XMDesgin.b1, iconName: "system_down", enable: agreeList.count == warnings.count) {
                vm.pageProgress = .Login_PhoneNumberInput
            }
            .rotationEffect(.degrees(-90))
        }
    }

    var rules: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            ForEach(warnings.indices, id: \.self) { index in
                let text = warnings[index]
                let selected = agreeList.contains(text)

                XMDesgin.SelectionTable(text: text, selected: selected) {
                    Apphelper.shared.mada(style: .soft)
                    if selected {
                        agreeList.removeAll { target in
                            target == text
                        }
                    } else {
                        agreeList.append(text)
                    }
                }
                .transition(.movingParts.skid(direction: .leading).animation(.spring.delay(Double(index) * 0.4)))
                .ifshow(show: showBtns)
            }
        })
        .shadow(.drop(color: Color.XMDesgin.b1.opacity(0.6), radius: 12, x: 0, y: 0))
        .padding(.bottom, 60)
    }
}

#Preview {
    AppWarningView().environmentObject(LoginViewModel())
}
