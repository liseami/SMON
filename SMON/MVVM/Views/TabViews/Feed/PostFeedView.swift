//
//  ThreadView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI
import SwiftUIX

struct PostFeedView: View {
    @StateObject var vm: FeedViewModel = .init()

    var body: some View {
        ZStack(alignment: .top, content: {
            // 动态流
            tabView
            // 顶部模糊
            XMTopBlurView()
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // 顶部导航栏
                toptabbar
            }
            ToolbarItem(placement: .topBarLeading) {
                //  通知按钮
                XMDesgin.XMIcon(iconName: "home_bell", size: 22)
            }
            ToolbarItem(placement: .topBarTrailing) {
                // 筛选按钮
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

    var toptabbar: some View {
        HStack {
            Spacer()
            ForEach(FeedViewModel.FeedTopBarItem.allCases, id: \.self) { tabitem in
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
                    PostListView()
                        .tag(FeedViewModel.FeedTopBarItem.near)
                    PostListView()
                        .tag(FeedViewModel.FeedTopBarItem.localCity)
                    CompetitionView()
                        .tag(FeedViewModel.FeedTopBarItem.competition)
                    PostListView()
                        .tag(FeedViewModel.FeedTopBarItem.hot)
                    PostListView()
                        .tag(FeedViewModel.FeedTopBarItem.flow)

                })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
//    FeedView()
    MainView(vm: MainViewModel(currentTabbar: .feed))
}
