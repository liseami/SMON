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
            topBar
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
                        .font(.body)
                        .bold()
                        .opacity(selected ? 1 : 0.6)
                }
            }
            Spacer()
        }
    }

    var topBar: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
            .blur(radius: 12)
            .padding([.horizontal, .top], -30)
            .frame(height: 90)
            .ignoresSafeArea()
    }

    var tabView: some View {
        TabView(selection: $vm.currentTopTab,
                content: {
                    ForEach(FeedViewModel.FeedTopBarItem.allCases, id: \.self) { tab in
                        // 帖子流页面
                        PostListView().tag(tab)
                          
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
//    FeedView()
    MainView(vm: MainViewModel(currentTabbar: .feed))
}
