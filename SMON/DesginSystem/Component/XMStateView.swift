//
//  XMScrollView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/4.
//

import SwiftUI
import SwiftUIX

struct XMStateView<ListData: RandomAccessCollection, Item: Identifiable, Content: View, Loading: View, Empty: View>: View {
    var reqStatus: XMRequestStatus
    var loadmoreStatus: XMRequestStatus
    var getListData: () async -> ()
    var loadMore: () async -> ()
    let loading: Loading
    let pagesize: Int
    let empty: Empty
    let content: Content
    let list: ListData

    @MainActor public init<RowContent: View>(
        _ ListData: ListData,
        reqStatus: XMRequestStatus = .isLoading,
        loadmoreStatus: XMRequestStatus = .isLoading,
        pagesize: Int = 20,
        @ViewBuilder rowContent: @escaping (ListData.Element) -> RowContent,
        @ViewBuilder loadingView: @escaping () -> Loading,
        @ViewBuilder emptyView: @escaping () -> Empty,
        loadMore: @escaping () async -> () = {},
        getListData: @escaping () async -> () = {}
    ) where Item == ListData.Element, Content == ForEach<ListData, ListData.Element.ID, RowContent> {
        self.empty = emptyView()
        self.list = ListData
        self.content = ForEach(ListData, content: rowContent)
        self.loading = loadingView()
        self.reqStatus = reqStatus
        self.loadMore = loadMore
        self.loadmoreStatus = loadmoreStatus
        self.getListData = getListData
        self.pagesize = pagesize
    }

    @MainActor public init(
        _ ListData: ListData,
        reqStatus: XMRequestStatus = .isLoading,
        loadmoreStatus: XMRequestStatus = .isLoading,
        pagesize: Int = 20,
        @ViewBuilder customContent: @escaping () -> Content,
        @ViewBuilder loadingView: @escaping () -> Loading,
        @ViewBuilder emptyView: @escaping () -> Empty,
        loadMore: @escaping () async -> () = {},
        getListData: @escaping () async -> () = {}
    ) where Item == ListData.Element {
        self.empty = emptyView()
        self.list = ListData
        self.content = customContent()
        self.loading = loadingView()
        self.reqStatus = reqStatus
        self.loadMore = loadMore
        self.loadmoreStatus = loadmoreStatus
        self.getListData = getListData
        self.pagesize = pagesize
    }

    var body: some View {
        Group {
            switch reqStatus {
            case .isLoading:
                loading
                    .transition(.opacity.animation(.easeOut(duration: 0.2)))
                    .frame(maxWidth: .infinity)
            case .isNeedReTry:
                XMPleaceHolderView(imageName: "networkerror_pagepic", text: "APP高级功能。您的权限不足。请刷新重试。", btnText: "重试") {
                    await getListData()
                }

            case .isOK:
                content
                Group {
                    switch loadmoreStatus {
                    case .isLoading:
                        ProgressView()
                            .frame(height: 60, alignment: .center)
                    case .isOK:
                        Color.clear
                            .frame(width: 1, height: 59, alignment: .center)
                        Color.clear
                            .frame(width: 1, height: 1, alignment: .center)
                            .task {
                                await self.loadMore()
                            }
                            .offset(y: 40)
                    case .isNeedReTry:
                        XMDesgin.XMMainBtn(text: "加载失败，请重试") {
                            await waitme(sec: 1)
                            await loadMore()
                        }
                        .frame(width: 240)
                    case .isOKButEmpty:
                        Text("--- 没有更多了 ---")
                            .font(.XMFont.f2)
                            .fcolor(.XMColor.f2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .ifshow(show: self.list.count >= pagesize)

            case .isOKButEmpty:
                empty
                    .frame(maxWidth: .infinity)
            }
        }
        .transition(.opacity
            .combined(with: .offset(y: 20))
            .combined(with: .scale(scale: 0.98))
            .animation(.easeOut))
    }
}

#Preview {
    ScrollView {
        XMStateView([XMPost(), XMPost(), XMPost(), XMPost(), XMPost(), XMPost(), XMPost(), XMPost(), XMPost(), XMPost(), XMPost()], reqStatus: .isNeedReTry, loadmoreStatus: .isNeedReTry) { post in
            PostView(post)
        } loadingView: {
            ProgressView()
        } emptyView: {
            Text("暂无内容")
        } loadMore: {}
    }
}
