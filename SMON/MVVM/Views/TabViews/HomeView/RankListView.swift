//
//  RankListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI
class RanklistViewModel: XMListViewModel<XMUserInRank> {
    init() {
        super.init(pageName: "") { _ in
            RankAPI.country
        }
    }
}

struct RankListView: View {
    @StateObject var vm: RanklistViewModel = .init()

    var body: some View {
        ScrollView {
            XMStateView(reqStatus: vm.reqStatus) {
                rankList
            } loading: {
                RankListLoadingView()
            } empty: {
                XMEmptyView()
            }
        }
        .scrollIndicators(.hidden)
        .refreshable { await vm.getListData() }
    }

    var rankList: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            ForEach(Array(vm.list.enumerated()), id: \.offset) { index, user in
                XMDesgin.XMButton {
                    MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profile(userId: user.userId))
                } label: {
                    VStack {
                        WebImage(str: user.avatar)
                            .scaledToFill()
                            .frame(width: 100, height: 100) // Adjust the size as needed
                            .clipShape(Circle())
                        Text(user.nickname)
                            .font(.XMFont.f1b)
                            .lineLimit(1)
                        Text(user.cityName.or("未知"))
                            .font(.XMFont.f3)
                            .fcolor(.XMDesgin.f2)
                    }
                }
                .conditionalEffect(.smoke(layer: .local), condition: index < 3)
            }
        }
        .padding(.all)
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .home))
}

struct RankListLoadingView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            ForEach(0 ... 33, id: \.self) { _ in
                VStack {
                    Circle()
                        .fill(Color.XMDesgin.b1.gradient)
                        .frame(width: 100, height: 100) // Adjust the size as needed
                        .clipShape(Circle())
                    Text("user.nickname")
                        .font(.XMFont.f1b)
                        .lineLimit(1)
                    Text("user.cityName")
                        .font(.XMFont.f3)
                        .fcolor(.XMDesgin.f2)
                }
                .redacted(reason: .placeholder)
                .conditionalEffect(.repeat(.shine, every: 1), condition: true)
            }
        }
        .padding(.all)
    }
}
