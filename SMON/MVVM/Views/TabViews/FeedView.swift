//
//  ThreadView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI
import SwiftUIX

struct FeedView: View {
    @StateObject var vm: HomeViewModel = .init()
    var body: some View {
        ZStack(alignment: .top, content: {
            tabView
            topBar
        })
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarColor(.clear)
        .navigationBarTransparent(true)
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

    var feedList: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [], content: {
                ForEach(0...120, id: \.self) { _ in
                    postView
                }
            })
        }
    }

    var tabView: some View {
        TabView(selection: $vm.currentTopTab,
                content: {
                    ForEach(HomeViewModel.HomeTopBarItem.allCases, id: \.self) { tab in
                        // 帖子流页面
                        feedList.tag(tab)
                    }
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.container, edges: .top)
    }

    var postView: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                AsyncImage(url: AppConfig.mokImage)
                    .scaledToFit()
                    .frame(width: 38, height: 38) // Adjust the size as needed
                    .clipShape(Circle())
                RoundedRectangle(cornerRadius: 99)
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(Color.XMDesgin.f2)
            }

            VStack(alignment: .leading) {
                HStack {
                    Text(String.randomChineseString(length: Int.random(in: 3...12)))
                        .font(.body.bold())
                        .lineLimit(1)
                        .foregroundStyle(Color.XMDesgin.f1)
                    Spacer()
                    Text("14小时前")
                        .font(.caption)
                        .foregroundStyle(Color.XMDesgin.f2)
                }
                Text(String.randomChineseString(length: Int.random(in: 12...144)))
                    .foregroundStyle(Color.XMDesgin.f1)
                    .font(.subheadline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        Spacer().frame(width: 16 + 38 + 12 - 4)
                        ForEach(0...3, id: \.self) { _ in
                            AsyncImage(url: AppConfig.mokImage) { image in
                                image.resizable(true)
                                    .scaledToFill()
                                    .frame(width: 160, height: 160 / 3 * 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                Color.XMDesgin.b1
                                    .frame(width: 160, height: 160 / 3 * 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        Spacer().frame(width: 12)
                    }
                }
                .frame(height: 160 / 3 * 4)
                .padding(.leading, -(16 + 38 + 12))
                .padding(.trailing, -16)
                HStack(alignment: .center, spacing: 12, content: {
                    HStack {
                        Text("14929")
                            .font(.caption)
                            .bold()
                        XMDesgin.XMIcon(iconName: "feed_heart", size: 16)
                            .padding(.all, 6)
                            .background(Color.XMDesgin.b1)
                            .clipShape(Circle())
                    }
                    HStack {
                        XMDesgin.XMIcon(iconName: "feed_comment", size: 16)
                            .padding(.all, 6)
                            .background(Color.XMDesgin.b1)
                            .clipShape(Circle())
                    }
                    Spacer()
                    XMDesgin.XMIcon(iconName: "system_more", size: 16)
                        .padding(.all, 6)
                        .background(Color.XMDesgin.b1)
                        .clipShape(Circle())
                })
                .padding(.top, 6)

                Text("145评论")
                    .font(.caption)
                    .bold()
                    .padding(.top, 6)
                    .background(content: {
                        Color.black
                    })
                    .padding(.leading, -(38 + 12))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

#Preview {
//    FeedView()
    MainView(vm: MainViewModel(currentTabbar: .feed))
}
