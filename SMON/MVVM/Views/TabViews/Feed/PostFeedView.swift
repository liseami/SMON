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
        }
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
                    PostListView(target: PostAPI.nearbyList(page: 1))
                        .tag(FeedViewModel.FeedTopBarItem.near)

                    PostListView(target: PostAPI.sameCityList(page: 1))
                        .tag(FeedViewModel.FeedTopBarItem.localCity)
                    // 每日大赛
                    MeiRiDaSaiView()
                        .tag(FeedViewModel.FeedTopBarItem.competition)

                    PostListView(target: PostAPI.recommendList(page: 1))
                        .tag(FeedViewModel.FeedTopBarItem.hot)
                    PostListView(target: PostAPI.followList(page: 1))
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
