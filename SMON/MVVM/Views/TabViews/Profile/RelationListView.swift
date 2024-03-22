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
        super.init(target: UserRelationAPI.followersList(lastUserId: ""))
    }

    @Published var currentTab: TabbarItem = .firend
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
                .onChange(of: vm.currentTab) { _ in
//                    switch currentTab {
//                    case .fans:
//                        vm.target = UserRelationAPI.fansList(lastUserId: "")
//                    case .firend:
//                        vm.target =
//                            UserRelationAPI.fansList(lastUserId: "")
//                    case .fllow:
//                        vm.target =
//                            UserRelationAPI.followersList(lastUserId: "")
//                    }
                }
            // list
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                    ForEach(vm.list, id: \.userId) { _ in
                        XMUserLine()
                    }
                })
                .padding(.all, 16)
            })
        })
        .navigationTitle("朋友")
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
