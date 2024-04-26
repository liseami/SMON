//
//  HotHistoryView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import SwiftUI

struct HotHistroy: Convertible, Identifiable {
    var id: String = "" // ": 1775081130106683392,
    var userId: String = "" // ": 1764610746026688512,
    var eventTitle: String = "" // ": "火苗兑换",
    var addPopularity: String = "" // ": 100.00,
    var createdAtStr: String = "" // ": "04-02 16:41"
}

class HotHistoryViewModel: XMListViewModel<HotHistroy> {
    init() {
        super.init(target: UserAssetAPI.getHotRecord(page: 1),pagesize: 20)
        Task { await self.getListData() }
    }
}

struct HotHistoryView: View {
    @StateObject var vm: HotHistoryViewModel = .init()
    var body: some View {
        List {
            XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { item in
                row(item)
            } loadingView: {
                ProgressView()
            } emptyView: {
                XMEmptyView()
            } loadMore: {
                await vm.loadMore()
            } getListData: {
                await vm.getListData()
            }
        }
        .listStyle(.plain)
        .toolbarRole(.editor)
        .navigationTitle("热度明细")
    }

    func row(_ item: HotHistroy) -> some View {
        HStack(spacing: 16) {
            XMDesgin.XMIcon(iconName: "profile_hot_history")
                .frame(width: 56, height: 56, alignment: .center)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4, content: {
                Text(item.eventTitle)
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.f1)
                Text(item.createdAtStr)
                    .font(.XMFont.f3)
                    .fcolor(.XMDesgin.f2)
            })
            Spacer()
            Text(Int(item.addPopularity) ?? 0 > 0 ? "+\(item.addPopularity)" : item.addPopularity)
                .font(.XMFont.big3.bold())
                .fcolor(Int(item.addPopularity) ?? 0 > 0 ? .green : .XMDesgin.f1)
        }
    }
}

#Preview {
    HotHistoryView()
}
