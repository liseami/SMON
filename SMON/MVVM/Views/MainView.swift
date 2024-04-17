//
//  MainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import Introspect
import SwiftUI
import TUIChat

struct MainView: View {
    @StateObject var vm: MainViewModel = .shared
    var body: some View {
        NavigationStack(path: $vm.pathPages) {
            ZStack {
                // 一级页面
                tabViews
                // Tabbar
                MainTabbar()
                // 启动动画
                LaunchScreenAnimation()
            }
            .environmentObject(vm)
            .navigationBarTransparent(true)
            .navigationDestination(for: MainViewModel.PagePath.self) { path in
                Group {
                    switch path {
                    case .notification: NotificationView()
                    case .setting: SettingView()
                    case .myhotinfo: MyHotInfoView()
                    case .myfriends: RelationListView()
                    case .postdetail(let postId): PostDetailView(postId)
                    case .profileEditView: ProfileEditView()
                    case .profile(let userId): ProfileView(userId: userId)
                    case .chat(let userId): ChatView(userId: userId)
                    case .flamedetail: FlameDetailView()
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
//                HomeView()
                RankView()
            case .feed:
                // 信息流
                PostFeedView()
            case .message:
                // 消息
                MessageView()
            case .profile:
                // 个人主页
                ProfileHomeView()
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                // 通知按钮
//                XMDesgin.XMButton {
//                    MainViewModel.shared.pushTo(MainViewModel.PagePath.notification)
//                } label: {
//                    XMDesgin.XMIcon(iconName: "home_bell", size: 22)
//                }
//            }
//        }
    }
}

#Preview {
    MainView()
        .environment(\.colorScheme, .dark)
}
