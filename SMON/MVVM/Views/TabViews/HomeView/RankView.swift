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
                    LoadingTask(loadingMessage: "强制等待...") {}
                } label: {
                    XMDesgin.XMIcon(iconName: "home_bell", size: 22)
                }
            }
        }
    }

    var tabView: some View {
        TabView(selection: $vm.currentTopTab,
                content: {
                    // 附近的人
                    ZStack(alignment: .top) {
                        if vm.currentTopTab == .near {
                            NearRankView()
                        } else {
                            Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .environmentObject(vm)
                    .tag(RankViewModel.HomeTopBarItem.near)

                    // 其他四个页面，接口请求固定，无筛选
                    ForEach([RankViewModel.HomeTopBarItem.localCity, RankViewModel.HomeTopBarItem.all, RankViewModel.HomeTopBarItem.fans, RankViewModel.HomeTopBarItem.flow, RankViewModel.HomeTopBarItem.vistor], id: \.self) { tab in
                        // 排行榜页面
                        ZStack(alignment: .top) {
                            if vm.currentTopTab == tab {
                                RankListView(target: vm.target(for: tab))
                            } else {
                                Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .environmentObject(vm)
                        .tag(tab)
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
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
}

#Preview {
    MainView(vm: .init(currentTabbar: .home))
}
