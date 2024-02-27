//
//  WarningView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct AppWarningView: View {
    let warnings = ["我不会将App分享给对小众文化不了解的「圈外人」。", "我不会将App中的「用户内容」分享到广域社交网络中。", "我对「开放式关系」和「亚文化」没有歧视，始终保持着友好、阳光、乐观的态度来对待陌生人。", "我同意「每日大赛」的《用户协议》与《隐私政策》。"]
    @State var agreeList: [String] = []
    @State var showBtns: Bool = false
    @State var shake: Bool = false
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("我们需要知道这个App是否适合为您服务")
                .bold()
                .font(.title)

            VStack(alignment: .leading, spacing: 12, content: {
                ForEach(warnings.indices, id: \.self) { index in
                    let text = warnings[index]
                    let selected = agreeList.contains(text)
                    HStack(spacing: 16) {
                        Text(text)
                        Spacer()
                        Image(systemName: "circle")
                            .overlay(alignment: .center) {
                                Circle()
                                    .fill(Color.XMDesgin.f1)
                                    .frame(width: 10, height: 10)
                                    .ifshow(show: selected)
                            }
                    }
                    .padding(.all)
                    .background(Color.XMDesgin.b1)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
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

            XMDesgin.CircleBtn(backColor: Color.XMDesgin.f1, fColor: Color.XMDesgin.b1, iconName: "system_down") {}
                .disabled(true)
                .onTapGesture(perform: {
                    if agreeList.count != warnings.count {
                        shake.toggle()
                    } else {
                        Apphelper.shared.findGlobalNavigationController()?.pushViewController(LoginView_PhoneNumber().host(), animated: true)
                    }

                })
                .rotationEffect(.degrees(-90))
                .changeEffect(.shake, value: shake)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .onAppear(perform: {
            withAnimation {
                showBtns = true
            }
        })
    }
}

#Preview {
    AppWarningView()
}
