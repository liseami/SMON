//
//  HomeView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI
import SwiftUIX

struct HomeView: View {
    @StateObject var vm: HomeViewModel = .init()
    @State var showFliterView: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            // 横向翻页
            tabView
                .ignoresSafeArea(.container, edges: .top)
            // 顶部导航
            topBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Spacer()
                    ForEach(HomeViewModel.HomeTopBarItem.allCases, id: \.self) { tabitem in
                        let selected = tabitem == vm.currentTopTab
                        Text(tabitem.info.name)
                            .font(.body)
                            .bold()
                            .opacity(selected ? 1 : 0.6)
                    }
                    Spacer()
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                XMDesgin.XMIcon(iconName: "home_bell", size: 22)
            }
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMIcon(iconName: "home_fliter", size: 22)
                    .onTapGesture {
                        showFliterView.toggle()
                    }
                    .fullScreenCover(isPresented: $showFliterView, content: {
                        HomeFliterView()
                            .environment(\.colorScheme, .dark)
                    })
            }
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
                    ForEach(HomeViewModel.HomeTopBarItem.allCases, id: \.self) { tab in
                        // 排行榜页面
                        rankList.tag(tab)
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
    }

    var rankList: some View {
        ScrollView {
//            Spacer().frame(height: 44)
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                ForEach(0...99, id: \.self) { _ in
                    VStack {
                        AsyncImage(url: AppConfig.mokImage)
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
    MainView(vm: .init(currentTabbar: .home))
}
