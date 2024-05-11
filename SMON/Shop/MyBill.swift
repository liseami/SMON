//
//  MyBill.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/24.
//

import SwiftUI

struct XMBillRecord: Identifiable, Convertible {
    var id: String = "" //  : 9,
    var userId: String = "" // ": 1764610746026688512,
    var eventTitle: String = "" // ": "赠送礼物",
    var addCoin: String = "" // ": -1,
    var createdAtStr: String = "" // ": "38分钟前"
}

class MyBillViewModel: XMListViewModel<XMBillRecord> {
    init() {
        super.init(target: UserAssetAPI.billRecord(page: 1))
        Task { await self.getListData() }
    }
}

struct MyBill: View {
    @StateObject var vm: MyBillViewModel = .init()
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 12, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 1) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 4, content: {
                            Text(record.eventTitle)
                                .font(.XMFont.f1b)
                            Text(record.createdAtStr)
                                .font(.XMFont.f3)
                        })
                        Spacer()
                        record.addCoin.inBillListText
                            .font(.XMFont.big3.bold())
                    }
                    .padding(.all, 12)
                    .background(Color.XMColor.b1)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } loadingView: {
                    ProgressView()
                } emptyView: {
                    XMEmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }

            })
            .padding(.all)
        }
        .navigationTitle("赛币账单")
    }
}

#Preview {
    MyBill()
}
