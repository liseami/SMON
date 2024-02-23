//
//  MainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm: MainViewModel = .init()
    var body: some View {
        ZStack {
            // 一级页面
            tabViews
            // Tabbar
            tabbar
        }
    }

    var tabViews: some View {
        Group {
            switch vm.currentTabbar {
            case .home:
                HomeView()
            case .feed:
                ThreadView()
            case .message:
                MessageView()
            case .profile:
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
