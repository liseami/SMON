//
//  RankListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI
class RanklistViewModel: XMListViewModel<XMUserInRank> {
    override init(target: XMTargetType, pagesize: Int) {
        super.init(target: target, pagesize: 50)
        Task { await self.getListData() }
    }
}

struct RankListView: View {
    @StateObject var vm: RanklistViewModel
    @EnvironmentObject var superVm: RankViewModel
    init(target: XMTargetType) {
        self._vm = StateObject(wrappedValue: .init(target: target, pagesize: 50))
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 0, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 50, customContent: {
                    rankList
                }) {
                    RankListLoadingView()
                } emptyView: {
                    XMEmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }
            })
        }
        .scrollIndicators(.hidden)
        .refreshable { await vm.getListData() }
    }

    var rankList: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            ForEach(Array(vm.list.enumerated()), id: \.offset) { index, user in
                VStack {
                    XMUserAvatar(str: user.avatar, userId: user.userId, size: 100)
                        .conditionalEffect(.smoke(layer: .local), condition: index < 3)
                    Text(user.nickname)
                        .font(.XMFont.f1b)
                        .lineLimit(1)
                    Text(user.cityName.or("未知"))
                        .font(.XMFont.f3)
                        .fcolor(.XMDesgin.f2)
                }
            }
        }
        .padding(.all)
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .home))
        .environmentObject(RankViewModel())
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
