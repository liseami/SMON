//
//  NearRankView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/27.
//

import CoreLocation
import SwiftUI
class NearRankViewModel: XMListViewModel<XMUserInRank> {
    init() {
        let mod = UserManager.shared.NearbyFliterMod
        self.filterMod_APIUse = mod
        super.init(target: RankAPI.nearby(page: 1, fliter: mod), pagesize: 50)
    }

    // 接口入参模型，发生变动，自动请求接口
    @Published var filterMod_APIUse: FliterMod {
        didSet {
            target = RankAPI.nearby(page: 1, fliter: filterMod_APIUse)
            Task { await getListData() }
        }
    }
}

struct NearRankView: View {
    @StateObject var vm: NearRankViewModel = .init()
    @EnvironmentObject var superVm: RankViewModel
    @State private var isLoadingUserLocation: Bool = false

    // 请求数据
    func reqData() async {
        // 权限OK，请求接口
        isLoadingUserLocation = true
        if UserManager.shared.userlocation.lat != "" {
            await vm.getListData()
            isLoadingUserLocation = false
        } else {
            LocationManager.shared.startUpdatingLocation {
                await self.vm.getListData()
                isLoadingUserLocation = false
            }
        }
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
        }
        .overlay {
            AutoLottieView(lottieFliesName: "radar", loopMode: .loop, speed: 1)
                .scaleEffect(2)
                .ifshow(show: isLoadingUserLocation)
        }
        .task {
            // 初始化时，检查用户权限，没有打开权限，则弹窗提示
            if CLLocationManager().authorizationStatus.rawValue < 3 {
                Apphelper.shared.presentPanSheet(
                    RequestUserLocationAuthorizationView()
                        .environmentObject(self.vm),
                    style: .setting)
            } else {
                Task { await reqData() }
            }
        }
        // 用户从设置回到了APP时
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.APP_GO_TO_ACTIVE, object: nil)) { _ in
            // 检查最新状态
            if CLLocationManager().authorizationStatus.rawValue >= 3 {
                // 回到APP，用户已授权
                Apphelper.shared.closeSheet()
                Task { await reqData() }
            } else {
                Apphelper.shared.pushNotification(type: .error(message: "授权仍未打开。"))
                superVm.currentTopTab = .localCity
            }
        }
        .scrollIndicators(.hidden)
        .refreshable { await vm.getListData() }
        .toolbar(content: {
            // 筛选按钮
            ToolbarItem(placement: .topBarTrailing) {
                fliterBtn
            }
        })
    }

    var fliterBtn: some View {
        XMDesgin.XMButton(action: {
            Apphelper.shared.presentPanSheet(
                // 筛选项调节
                HomeFliterView(mod: self.vm.filterMod_APIUse)
                    .environmentObject(vm)
                    .environment(\.colorScheme, .dark), style: .cloud)
        }, label: {
            XMDesgin.XMIcon(iconName: "home_fliter", size: 22)
        })
    }

    var rankList: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            ForEach(Array(vm.list.enumerated()), id: \.offset) { index, user in
                VStack {
                    XMUserAvatar(str: user.avatar, userId: user.userId, size: 100)
                        .conditionalEffect(.smoke(layer: .local), condition: index < 3)
                    VStack(alignment: .center, spacing: 4) {
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
                        
                        Text(user.distanceStr)
                            .font(.XMFont.f3)
                            .fcolor(.XMColor.f2)
                    }
                }
            }
        }
        .padding(.all)
    }
}

#Preview {
    NearRankView()
        .environmentObject(RankViewModel())
}
