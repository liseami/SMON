//
//  ThreadView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

struct FeedView: View {
    @StateObject var vm : HomeViewModel = .init()
    var body: some View {
        ZStack(alignment: .top, content: {
            List {
                Spacer().frame(height:24)
                    .listRowSeparator(.hidden)
                ForEach(0...120, id: \.self) { _ in
                    postView
                }
            }
            .listStyle(.plain)
            topBar
        })
    }
    
    var topBar: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.8), Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 85)
            HStack {
                XMDesgin.XMIcon(iconName: "home_bell",size: 22)
                Spacer()
                ForEach(HomeViewModel.HomeTopBarItem.allCases, id: \.self) { tabitem in
                    let selected = tabitem == vm.currentTopTab
                    Text(tabitem.info.name)
                        .font(.body)
                        .bold()
                        .opacity(selected ? 1 : 0.6)
                }
                Spacer()
                XMDesgin.XMIcon(iconName: "home_shop",size: 22)
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
    }

    var postView: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: "https://i.pravatar.cc/300")!)
                .scaledToFit()
                .frame(width: 38, height: 38) // Adjust the size as needed
                .clipShape(Circle())
            VStack(alignment: .leading) {
                HStack {
                    Text(String.randomChineseString(length: Int.random(in: 3...12)))
                        .font(.body.bold())
                        .lineLimit(1)
                    Spacer()
                    Text("14小时前")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    XMDesgin.XMIcon(systemName: "ellipsis", size: 12,color: .secondary)
                }
                Text(String.randomChineseString(length: Int.random(in: 12...144)))
                    .font(.subheadline)
            }
        }
        .padding(.vertical,12)
        .padding(.horizontal,8)
    }
}

#Preview {
//    FeedView()
    MainView(vm: MainViewModel(currentTabbar: .feed))
}
