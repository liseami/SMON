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
                    "我不会将App中的「用户内容」分享到广域社交网络中"]
    @State var agreeList: [String] = []
    @State var showBtns: Bool = false
    @State var openUrl : URL?
    @State var openUrlSheet : Bool = false
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
                        .transition(.movingParts.flip.animation(.easeInOut.delay(Double(index) * 0.2)))
                        .ifshow(show: showBtns)
                    }
                })
                .shadow(.drop(color: .black, radius: 24, x: 0, y: 0))
                .padding(.bottom, 60)

                HStack {
                    Text(LocalizedStringKey("点击下一步，即代表您已阅读并同意「每日大赛」的[《用户协议》](https://www.baidu.com) 与 [《隐私政策》](https://www.baidu.com)。"))
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.XMDesgin.f2)
                        .frame(width: 240)
                        .tint(Color.XMDesgin.main)
                        .environment(\.openURL, OpenURLAction { url in
                            self.openUrl = url
                            openUrlSheet = true
                          return .handled
                        })
                    Spacer()
                    XMDesgin.CircleBtn(backColor: Color.white, fColor: Color.XMDesgin.b1, iconName: "system_down", enable: agreeList.count == warnings.count) {
                        vm.pageProgress = .Login
                    }
                    .rotationEffect(.degrees(-90))
                }
            }
            .padding()
        }
        .sheet(isPresented: $openUrlSheet, content: {
            if let openUrl{
                InAppBrowser(url: openUrl)
                    .preferredColorScheme(.dark)
            }else{
                EmptyView()
            }
        })
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
