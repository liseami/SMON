//
//  HomeView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel = .init()
    @State var showFliterView: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            // 横向翻页
            tabView
            // 顶部导航
            topBar
        }
    }

    var topBar: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.8), Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 85)
            HStack {
                XMDesgin.XMIcon(iconName: "home_bell", size: 22)
                Spacer()
                ForEach(HomeViewModel.HomeTopBarItem.allCases, id: \.self) { tabitem in
                    let selected = tabitem == vm.currentTopTab
                    Text(tabitem.info.name)
                        .font(.body)
                        .bold()
                        .opacity(selected ? 1 : 0.6)
                }
                Spacer()
                XMDesgin.XMIcon(iconName: "home_fliter", size: 22)
                    .onTapGesture {
                        showFliterView.toggle()
                    }
                    .fullScreenCover(isPresented: $showFliterView, content: {
                        HomeFliterView()
                            .environment(\.colorScheme, .dark)
                    })
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
    }

    var tabView: some View {
        TabView(selection: $vm.currentTopTab,
                content: {
                    ForEach(HomeViewModel.HomeTopBarItem.allCases, id: \.self) { tab in
                        // 排行榜页面
                        rankList
                            .tag(tab)
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
    }

    var rankList: some View {
        ScrollView {
            Spacer().frame(height: 85)
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                ForEach(0...99, id: \.self) { _ in
                    VStack {
                        AsyncImage(url: URL(string: "https://i.pravatar.cc/300")!)
                            .scaledToFit()
                            .frame(width: 100, height: 100) // Adjust the size as needed
                            .clipShape(Circle())
                        Text(String.randomChineseString(length: Int.random(in: 2...8)))
                            .font(.subheadline)
                            .bold()
                            .lineLimit(1)
                        Text("苏州")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.all)
        }.scrollIndicators(.hidden)
            .refreshable {}
    }
}

#Preview {
    HomeView()
}
