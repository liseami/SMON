//
//  RankListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI
class RanklistViewModel: XMListViewModel<XMUserInRank> {
    override init(target: XMTargetType, pagesize: Int, atKeyPath: String = .datalist) {
        super.init(target: target, pagesize: 50)
        Task { await self.getListData() }
    }
}

struct RankListView: View {
    @StateObject var vm: RanklistViewModel
    @EnvironmentObject var superVm: RankViewModel
    private let date = Date()
    @State private var show: Bool = false
    init(target: XMTargetType) {
        self._vm = StateObject(wrappedValue: .init(target: target, pagesize: 50))
    }

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
            .background(alignment: .top) {
                fire
                    .transition(.movingParts.move(edge: .top).animation(.bouncy))
                    .ifshow(show: show)
            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        show = true
                    }
                }
            })
        }

        .scrollIndicators(.hidden)
        .refreshable { await vm.getListData() }
    }

    @ViewBuilder
    var fire: some View {
        if #available(iOS 17.0, *) {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                let targetHeight = UIScreen.main.bounds.width + offset
                let scale = targetHeight / UIScreen.main.bounds.width
                let blurRadius = offset < 0 ? abs(offset) / UIScreen.main.bounds.width * 66 : 0
                TimelineView(.animation) {
                    let time = date.timeIntervalSince1970 - $0.date.timeIntervalSince1970
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                        .colorEffect(ShaderLibrary.gradientWave(
                            .boundingRect,
                            .float(time),
                            .color(.black),
                            .float(5),
                            .float(0),
                            .float(0.4)
                        ))
                        .ignoresSafeArea()
                }
                .offset(x: 0, y: -80)
                .scaleEffect(scale, anchor: .top)
                .offset(y: -offset)
                .blur(radius: blurRadius)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            .ifshow(show: superVm.currentTopTab == .all)
        }
    }

    var rankList: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            ForEach(Array(vm.list.enumerated()), id: \.offset) { index, user in
                VStack {
                    XMUserAvatar(str: user.avatar, userId: user.userId, size: 100)
                        .conditionalEffect(.smoke(layer: .local), condition: index < 3 && self.show)
                        .overlay {
                            Group {
                                if #available(iOS 17.0, *) {
                                    TimelineView(.animation) {
                                        let time = date.timeIntervalSince1970 - $0.date.timeIntervalSince1970
                                        Rectangle()
                                            .aspectRatio(1, contentMode: .fit)
                                            .colorEffect(ShaderLibrary.lightspeed(
                                                .boundingRect,
                                                .float(time),
                                                .float(12),
                                                .float(12),
                                                .float(24)
                                            ))
                                            .frame(width: 120, height: 120, alignment: .center)
                                    }
                                } else {
                                    EmptyView()
                                }
                            }
                            .mask(Circle().stroke(lineWidth: 5)
                                .frame(width: 100, height: 100, alignment: .center))
                            .blur(radius: 3)
                            .allowsHitTesting(false)
                            .ifshow(show:
                                user.userId == "1764504995815882752" ||
                                    user.userId == "1779306584749506560" ||
                                    index < 3 && self.show)
                        }

                    HStack{
                        Text(user.nickname)
                            .font(.XMFont.f1b)
                            .lineLimit(1)
                        
                        if user.vipLevel != 0{
                            Image("home_vipIcon")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                    
//                    Text("No.\(index)")
//                        .font(.XMFont.f3)
//                        .lineLimit(1)
                    
                }
            }
        }
        .padding(.all)
    }
}

#Preview {
//    PostListLoadingView()
    MainView(vm: .init(currentTabbar: .home))
        .environmentObject(RankViewModel())
}

struct RankListLoadingView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            ForEach(0 ... 33, id: \.self) { _ in
                VStack {
                    Circle()
                        .fill(Color.XMColor.b1.gradient)
                        .frame(width: 100, height: 100) // Adjust the size as needed
                        .clipShape(Circle())
                    Text("user.nickname")
                        .font(.XMFont.f1b)
                        .lineLimit(1)
                    Text("user.cityName")
                        .font(.XMFont.f3)
                        .fcolor(.XMColor.f2)
                }
                .redacted(reason: .placeholder)
                .conditionalEffect(.repeat(.shine, every: 1), condition: true)
            }
        }
        .padding(.all)
    }
}

struct PostListLoadingView: View {
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(0 ... 33, id: \.self) { _ in
                LoadingPostView()
                    .conditionalEffect(.repeat(.shine, every: 1), condition: true)
            }
        }
    }
}
