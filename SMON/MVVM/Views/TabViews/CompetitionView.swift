//
//  CompetitionView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import SwiftUI

struct CompetitionView: View {
    var body: some View {
        ZStack(alignment: .top) {
            // 横向翻页
            content
                .ignoresSafeArea(.container, edges: .top)
            // 顶部模糊
            XMTopBlurView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // 顶部导航栏
                topTabbar
            }
            ToolbarItem(placement: .topBarLeading) {
                // 通知按钮
                XMDesgin.XMButton {
                    LoadingTask(loadingMessage: "强制等待...") {
                        print(Apphelper.shared.cityName(forCityID: "340100"))
                    }
                } label: {
                    XMDesgin.XMIcon(iconName: "home_bell", size: 22)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                // 筛选按钮
                XMDesgin.XMButton {} label: {
                    XMDesgin.XMIcon(iconName: "home_fliter", size: 22)
                }
            }
        }
    }

    var topTabbar: some View {
        HStack {
            Spacer()
            ForEach(0 ... 2, id: \.self) { index in
//                let selected = tabitem == vm.currentTopTab
                XMDesgin.XMButton {
//                    vm.currentTopTab = tabitem
                } label: {
                    let text = index == 0 ? "前一天" : index == 1 ? "今天" : "后一天"
                    Text(text)
                        .font(.body)
                        .bold()
                        .opacity(text == "今天" ? 1 : 0.6)
                }
            }
            Spacer()
        }
    }

    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Spacer().frame(height: 120)
            LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                VStack(alignment: .center, spacing: 12, content: {
                    VStack(alignment: .center, spacing: 16, content: {
                        Text("包臀裙大赛")
                            .font(.body.bold())
                            .foregroundStyle(Color.XMDesgin.f1)
                        XMDesgin.SmallBtn(fColor: .XMDesgin.main, backColor: .XMDesgin.b1, iconName: "system_toggle", text: "切换至男生主题") {}
                        Text("快来秀出你的包臀裙照片吧，快来秀出你的包臀裙照片吧，快来秀出你的包臀裙照片吧。")
                            .font(.subheadline)
                            .foregroundStyle(Color.XMDesgin.f1)
                        XMDesgin.XMMainBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "立即参与发帖") {}
                            .overlay(alignment: .center) {
                                Capsule().stroke(lineWidth: 2)
                                    .foregroundColor(.XMDesgin.f2)
                            }
                        HStack {
                            Text("23992人参与 · ")
                            Text("3天后截止")
                        }
                        .font(.subheadline).monospaced()
                        .foregroundStyle(Color.XMDesgin.f2)
                    })
                    .padding(.top, 32)
                    .padding(.all, 16)
                    .background(Color.XMDesgin.b1)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(alignment: .top) {
                        WebImage(str: AppConfig.mokImage!.absoluteString)
                            .frame(width: 140, height: 140 / 16 * 9)
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(alignment: .center) {
                                RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 3)
                                    .foregroundColor(.XMDesgin.f1)
                            }
                            .offset(x: 0, y: -50)
                    }
                })
                .padding(.top, 40)

                HStack {
                    Text("热门")
                        .font(.headline.bold())
                        .foregroundStyle(Color.XMDesgin.b1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color.XMDesgin.f1)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Text("最新")
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.all, 4)
                .background(Color.XMDesgin.b1)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                ForEach(0 ... 100, id: \.self) { _ in
                    PostView()
                }
            })
            .padding(.all, 16)
        }
    }
}

#Preview {
    MainView(vm: .init())
}
