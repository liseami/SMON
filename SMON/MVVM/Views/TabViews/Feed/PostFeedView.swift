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
    @ObservedObject var userManager: UserManager = .shared
    var body: some View {
        ZStack(alignment: .top, content: {
            // 动态流
            tabView
            // 顶部模糊
            XMTopBlurView()
        })
        .task {
            await userManager.getUserInfo()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // 顶部导航栏
                toptabbar
            }

//            ToolbarItem(placement: .topBarLeading) {
//                //  通知按钮
//                XMDesgin.XMIcon(iconName: "home_bell", size: 22)
//            }
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
                    Group {
                        if tabitem == .localCity {
                            Text(userManager.user.cityName)
                        } else {
                            Text(tabitem.info.name)
                        }
                    }
                    .font(.XMFont.f1)
                    .bold()
                    .opacity(selected ? 1 : 0.6)
                }
            }
            Spacer()
        }
    }

    var tabView: some View {
        TabView(selection: $vm.currentTopTab) {
            ZStack(alignment: .top) {
                if vm.currentTopTab == .near {
                    NearPostView()
                } else {
                    Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .tag(FeedViewModel.FeedTopBarItem.near)
            .environmentObject(vm)

            tabContent(for: .localCity, target: PostAPI.sameCityList(page: 1))
                .tag(FeedViewModel.FeedTopBarItem.localCity)
                .ifshow(show: userManager.user.cityName.isEmpty == false )
            // 每日大赛，单独处理
            tabContent(for: .competition, target: nil)
                .tag(FeedViewModel.FeedTopBarItem.competition)
            tabContent(for: .hot, target: PostAPI.recommendList(page: 1))
                .tag(FeedViewModel.FeedTopBarItem.hot)
            tabContent(for: .flow, target: PostAPI.followList(page: 1))
                .tag(FeedViewModel.FeedTopBarItem.flow)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.container, edges: .top)
    }

    func tabContent(for tab: FeedViewModel.FeedTopBarItem, target: PostAPI?) -> some View {
        ZStack(alignment: .top) {
            if vm.currentTopTab == tab {
                if let target = target {
                    PostListView(target: target)
                } else {
                    MeiRiDaSaiView()
                }
            } else {
                Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .environmentObject(vm)
    }
}

#Preview {
//    FeedView()
    MainView(vm: MainViewModel(currentTabbar: .feed))
}
