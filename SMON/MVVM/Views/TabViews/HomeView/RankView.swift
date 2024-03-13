//
//  HomeView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI
import SwiftUIX

struct RankView: View {
    @StateObject var vm: RankViewModel = .init()
    @State var showFliterView: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            // 横向翻页
            tabView
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
            // 筛选按钮
            ToolbarItem(placement: .topBarTrailing) {
                fliterBtn
            }
        }
    }

    var fliterBtn: some View {
        XMDesgin.XMButton(action: {
            Apphelper.shared.presentPanSheet(HomeFliterView()
                .environment(\.colorScheme, .dark), style: .cloud)
        }, label: {
            XMDesgin.XMIcon(iconName: "home_fliter", size: 22)
        })
    }

    var topTabbar: some View {
        HStack {
            Spacer()
            ForEach(RankViewModel.HomeTopBarItem.allCases, id: \.self) { tabitem in
                let selected = tabitem == vm.currentTopTab
                XMDesgin.XMButton {
                    vm.currentTopTab = tabitem
                } label: {
                    Text(tabitem.info.name)
                        .font(.XMFont.f1)
                        .bold()
                        .opacity(selected ? 1 : 0.6)
                }
            }
            Spacer()
        }
    }

    var tabView: some View {
        TabView(selection: $vm.currentTopTab,
                content: {
                    ForEach(RankViewModel.HomeTopBarItem.allCases, id: \.self) { tab in
                        // 排行榜页面
                        RankListView(target: RankAPI.country).tag(tab)
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .home))
}