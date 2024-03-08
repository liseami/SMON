//
//  RankListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI
class RanklistViewModel: XMListDataViewModel<XMUserInRank> {}

struct RankListView: View {
    @StateObject var vm: RanklistViewModel
    init(target: XMTargetType) {
        self._vm = StateObject(wrappedValue: .init(target: target))
    }

    var body: some View {
        ScrollView {
            XMStateView(reqStatus: vm.reqStatus) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
                    ForEach(Array(vm.list.enumerated()), id: \.offset) { index, user in
                        XMDesgin.XMButton {
                            MainViewModel.shared.pathPages.append(.profile(userId: user.userId))
                        } label: {
                            VStack {
                                WebImage(str: user.avatar)
                                    .scaledToFill()
                                    .frame(width: 100, height: 100) // Adjust the size as needed
                                    .clipShape(Circle())
                                Text(user.nickname)
                                    .font(.XMFont.f1b)
                                    .lineLimit(1)
                                Text(user.cityName.or("未知"))
                                    .font(.XMFont.f3)
                                    .fcolor(.XMDesgin.f2)
                            }
                        }
                        .conditionalEffect(.smoke(layer: .local), condition: index < 3)
                    }
                }
                .padding(.all)
            } loading: {
                ProgressView()
            } empty: {}
        }.scrollIndicators(.hidden)
            .refreshable {}
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .home))
}
