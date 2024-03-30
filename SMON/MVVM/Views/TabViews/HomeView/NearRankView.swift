//
//  NearRankView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/27.
//

import SwiftUI

class NearRankViewModel: XMListViewModel<XMUserInRank> {
    init() {
        let mod = UserManager.shared.NearbyFliterMod
        self.filterMod_APIUse = mod
        super.init(target: RankAPI.nearby(page: 1, fliter: mod), pagesize: 50)
        Task { await self.getListData() }
    }

    // 接口入参模型，发生变动，自动请求接口
    @Published var filterMod_APIUse: FliterMod {
        didSet {
            target = RankAPI.nearby(page: 1, fliter: filterMod_APIUse)
            Task { await getListData() }
        }
    }
}

struct NearRankView: View {
    @StateObject var vm: NearRankViewModel = .init()
    @EnvironmentObject var superVm: RankViewModel

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
        .toolbar(content: {
            // 筛选按钮
            ToolbarItem(placement: .topBarTrailing) {
                fliterBtn
            }
        })
    }

    var fliterBtn: some View {
        XMDesgin.XMButton(action: {
            Apphelper.shared.presentPanSheet(
                // 筛选项调节
                HomeFliterView(mod: self.vm.filterMod_APIUse)
                    .environmentObject(vm)
                    .environment(\.colorScheme, .dark), style: .cloud)
        }, label: {
            XMDesgin.XMIcon(iconName: "home_fliter", size: 22)
        })
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
    NearRankView()
        .environmentObject(RankViewModel())
}
