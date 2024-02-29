//
//  MainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import Introspect
import SwiftUI

struct MainView: View {
    @StateObject var vm: MainViewModel = .init()
    var body: some View {
        NavigationView(content: {
            ZStack {
                // 一级页面
                tabViews
                // Tabbar
                tabbar
                // 启动动画
                LaunchScreenAnimation()
            }
        })
   
    }

    var tabViews: some View {
        Group {
            switch vm.currentTabbar {
            case .home:
                // 首页
                HomeView()
            case .feed:
                // 信息流
                FeedView()
            case .message:
                // 消息
                ConversationListView()
            case .profile:
                // 个人主页
                ProfileView()
            }
        }
    }

    var tabbar: some View {
        MainTabbar().environmentObject(vm)
    }
}

#Preview {
    MainView()
        .environment(\.colorScheme, .dark)
}
