//
//  FlameDetailView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/2.
//

import SwiftUI

struct FlameDetail: Convertible, Identifiable {
    var id: String = "" // 1,
    var userId: String = "" // 1764610746026688512,
    var nickname: String = "" // "zhanglu1385",
    var avatar: String = "" // "https://dailatar/default.jpg",
    var eventKey: String = "" // "fireDailySignIn",
    var eventTitle: String = "" // "每日签到",
    var addFlames: String = "" // 100,
    var createdAt: String = "" // 1711605981,
    var createdAtStr: String = "" // "14:06"
}

class FlameDetailViewModel: XMListViewModel<FlameDetail> {
    init() {
        super.init(target: UserAssetAPI.getUserFlamesRecord(page: 1), pagesize: 10, atKeyPath: .datalist)
        Task {
            await self.getListData()
        }
    }
}

struct FlameDetailView: View {
    @StateObject var vm: FlameDetailViewModel = .init()
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 12, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 10) { data in
                    makeRow(data)
                } loadingView: {
                    ProgressView()
                } emptyView: {
                    EmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }
            })
            .padding(.all)
        }
        .refreshable {
            await vm.getListData()
        }
        .navigationTitle("火苗历史明细")
    }

    func makeRow(_ data: FlameDetail) -> some View {
        return HStack(spacing: 16) {
            XMUserAvatar(str: data.avatar, userId: data.userId)
            VStack(alignment: .leading, spacing: 4, content: {
                Text(data.nickname)
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f1)
                Text(data.eventTitle)
                    .font(.XMFont.f2b)
                    .fcolor(.XMDesgin.f1)
                Text(data.createdAtStr)
                    .font(.XMFont.f3)
                    .fcolor(.XMDesgin.f2)

            })
            Spacer()
            Text(Int(data.addFlames) ?? 0 > 0 ? "+" + data.addFlames : data.addFlames)
                .font(.XMFont.big3.bold())
                .fcolor(Int(data.addFlames) ?? 0 > 0 ? .green : .red)
        }
    }
}

#Preview {
    FlameDetailView()
}
