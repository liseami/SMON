//
//  FeedListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI
import WaterfallGrid

class PostListViewModel: XMListViewModel<XMPost> {
    override init(target: XMTargetType, pagesize: Int = 20, atKeyPath: String = .datalist) {
        super.init(target: target, pagesize: 20)
        Task {
            await self.getListData()
        }
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}

struct PostListView: View {
    @StateObject var vm: PostListViewModel
    init(target: XMTargetType) {
        self._vm = StateObject(wrappedValue: .init(target: target))
    }

    var body: some View {
        switch vm.reqStatus {
        case .isLoading:
            StaggeredLayoutList(data: (1...12).compactMap({_ in  String.random(ofLength: 12)}), numberOfColumns: 2, horizontalSpacing: 6, verticalSpacing: 6) { _ in
                Color.XMColor.b1
                    .conditionalEffect(.repeat(.shine(duration: 0.5), every: 0.6), condition: true)
                    .frame(height: CGFloat.random(in: 160 ... 240))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(RoundedRectangle(cornerRadius: 8))
            }
        case .isNeedReTry:
            XMPleaceHolderView(imageName: "networkerror_pagepic", text: "APP高级功能。您的权限不足。请刷新重试。", btnText: "重试") {
                await vm.getListData()
            }
        case .isOK:
            ScrollView(.vertical) {
                LazyVStack(alignment: .center, spacing: 0, pinnedViews: [], content: {
                    WaterfallGrid(vm.list) { post in
                        PostCardView(post)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .ifshow(show: post.postAttachs.first?.picUrl.isEmpty == false)
                    }
                    .gridStyle(
                        columnsInPortrait: 2,
                        columnsInLandscape: 6
                    )
                    .scrollOptions(direction: .vertical)
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    Group {
                        switch vm.loadingMoreStatus {
                        case .isLoading:
                            ProgressView()
                                .frame(height: 60, alignment: .center)
                        case .isOK:
                            Color.clear
                                .frame(width: 1, height: 59, alignment: .center)
                            Color.clear
                                .frame(width: 1, height: 1, alignment: .center)
                                .task {
                                    await vm.loadMore()
                                }
                                .offset(y: 40)
                        case .isNeedReTry:
                            XMDesgin.XMMainBtn(text: "加载失败，请重试") {
                                await waitme(sec: 1)
                                await vm.loadMore()
                            }
                            .frame(width: 240)
                        case .isOKButEmpty:
                            Text("--- 没有更多了 ---")
                                .font(.XMFont.f2)
                                .fcolor(.XMColor.f2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .ifshow(show: vm.list.count >= vm.pagesize)
                })
            }
            .refreshable {
                await vm.getListData()
            }

        case .isOKButEmpty:
            VStack(spacing: 24) {
                Text("暂无帖子，快快发布吧！")
                    .font(.XMFont.f1)
                    .fcolor(.XMColor.f2)
                LoadingPostView()
            }
            .padding(.top, 12)
        }
    }
}

#Preview {
    PostListView(target: PostAPI.followList(page: 1))
}
