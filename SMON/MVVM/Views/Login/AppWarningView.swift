//
//  WarningView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct AppWarningView: View {
    @EnvironmentObject var vm: LoginViewModel
    let warnings = ["我不会将App分享给对小众文化不了解的「圈外人」",
                    "我对「开放式关系」和「亚文化」没有歧视，始终保持着友好、阳光、乐观的态度来对待陌生人",
                    "我不会将App中的「用户内容」分享到广域社交网络中",
                    "我已阅读并同意「每日大赛」的[《用户协议》](www.baidu.com) 与 [《隐私政策》](www.baidu.com)"]
    @State var agreeList: [String] = []
    @State var showBtns: Bool = false
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color.black.opacity(0)], startPoint: .bottom, endPoint: .top)
                .frame(height: UIScreen.main.bounds.height * 0.4)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()

                Text("我们需要知道这个App是否适合为您服务")
                    .bold()
                    .font(.title)

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
                        .transition(.movingParts.flip.animation(.easeInOut.delay(Double(index) * 0.1)))
                        .ifshow(show: showBtns)
                    }
                })

                XMDesgin.CircleBtn(backColor: Color.XMDesgin.f1, fColor: Color.XMDesgin.b1, iconName: "system_down", enable: agreeList.count == warnings.count) {
                    vm.pageProgress = .Login
                }
                .rotationEffect(.degrees(-90))
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
        .onAppear(perform: {
            withAnimation {
                showBtns = true
            }
        })
    }
}

#Preview {
    AppWarningView().environmentObject(LoginViewModel())
}
