//
//  MainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import Introspect
import SwiftUI

struct MainView: View {
    @StateObject var vm: MainViewModel = .shared
    var body: some View {
        NavigationStack(path: $vm.pathPages) {
            ZStack {
                // 一级页面
                tabViews
                // Tabbar
                tabbar
                // 启动动画
                LaunchScreenAnimation()
            }
            .onAppear(perform: {
//                Apphelper.shared.requestReviewApp()
//                LocationManager().requestLocationPermission()

            })
            .environmentObject(vm)
            .navigationBarTransparent(true)
            .navigationDestination(for: MainViewModel.PagePath.self) { path in
                Group {
                    switch path {
                    case .notification: NotificationView()
                    case .setting: SettingView()
                    case .coinshop: CoinshopView()
                    case .myhotinfo: MyHotInfoView()
                    case .myfriends: MyFriendsView()
                    case .postdetail(let postId): PostDetailView()
                    case .profileEditView: ProfileEditView()
                    case .profile(let userId): ProfileView(userId: userId)
                    }
                }
                .navigationBarTransparent(false)
                .toolbarRole(.editor)
            }
        }
    }

    var tabViews: some View {
        Group {
            switch vm.currentTabbar {
            case .home:
                // 首页
                HomeView()
            case .feed:
                // 信息流
                PostFeedView()
            case .message:
                // 消息
                ConversationListView()
            case .profile:
                // 个人主页
                ProfileHomeView()
            }
        }
    }

    var tabbar: some View {
        MainTabbar()
    }
}

#Preview {
    MainView()
        .environment(\.colorScheme, .dark)
}
