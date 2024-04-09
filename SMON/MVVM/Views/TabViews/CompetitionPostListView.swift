//
//  CompetitionPostListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import SwiftUI
class CompletionPostListViewModel: XMListViewModel<XMPost> {
    let type: Int
    let themeId: Int
    init(type: Int, themeId: Int) {
        self.type = type
        self.themeId = themeId
        super.init(target: PostAPI.themeList(p: .init(page: 1, type: type, themeId: themeId)))
        Task { await self.getListData() }
    }
}

struct CompetitionPostListView: View {
    @StateObject var vm: CompletionPostListViewModel
    @EnvironmentObject var superVM: MeiRiDaSaiViewModel

    init(type: Int, themeId: Int) {
        self._vm = StateObject(wrappedValue: .init(type: type, themeId: themeId))
    }

    var body: some View {
        XMStateView(vm.list,
                    reqStatus: vm.reqStatus,
                    loadmoreStatus: vm.loadingMoreStatus) { post in
            PostView(post)
        } loadingView: {
            PostListLoadingView()
        } emptyView: {
            Text("暂无内容")
        } loadMore: {
            await vm.loadMore()
        } getListData: {
            await vm.getListData()
        }
        .onChange(of: superVM.themeType) { _ in
            Task {
                await vm.getListData()
            }
        }
    }
}

#Preview {
    ScrollView {
        CompetitionPostListView(type: 1, themeId: 2)
            .environmentObject(MeiRiDaSaiViewModel())
    }
}
