//
//  MyFriendsView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import Combine
import SwiftUI

class RelationListViewModel: XMListViewModel<XMUserProfile> {
    init() {
        super.init(target: UserRelationAPI.friendList(page: 1))
        Task { await getListData() }
    }

    @Published var currentTab: TabbarItem = .firend {
        didSet {
            switch currentTab {
            case .fans:
                target = UserRelationAPI.friendList(page: 1)
            case .firend:
                target =
                    UserRelationAPI.fansList(page: 1)
            case .fllow:
                target =
                    UserRelationAPI.followersList(page: 1)
            }
            currentPage = 1
            Task { await getListData() }
        }
    }

    enum TabbarItem: CaseIterable {
        case firend
        case fllow
        case fans
        var titile: String {
            switch self {
            case .firend:
                return "朋友"
            case .fllow:
                return "关注"
            case .fans:
                return "粉丝"
            }
        }
    }

 
}

struct RelationListView: View {
    @StateObject var vm: RelationListViewModel = .init()
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            // tabbar
            tabbar
            // list
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                    XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus) { user in
                        XMUserLine(user: user)
                            
                    } loadingView: {
                        UserListLoadingView()
                    } emptyView: {
                        EmptyView()
                    } loadMore: {
                        await vm.loadMore()
                    } getListData: {
                        await vm.getListData()
                    }
                })
                .padding(.all, 16)
            })
            .refreshable {
                await vm.getListData()
            }
        })
        .navigationTitle(vm.currentTab.titile)
        .navigationBarTitleDisplayMode(.inline)
    }

    var tabbar: some View {
        HStack(alignment: .center, content: {
            ForEach(RelationListViewModel.TabbarItem.allCases, id: \.self) { tabbaritem in
                let selected = tabbaritem == vm.currentTab
                Text(tabbaritem.titile)
                    .font(selected ? .XMFont.f1b : .XMFont.f1)
                    .frame(maxWidth: .infinity)
                    .opacity(selected ? 1 : 0.66)
                    .onTapGesture {
                        Apphelper.shared.mada(style: .medium)
                        vm.currentTab = tabbaritem
                    }
            }

        })
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

#Preview {
    RelationListView()
}
