//
//  NearRankView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/27.
//

import CoreLocation
import SwiftUI
class NearPostViewModel: XMListViewModel<XMPost> {
    init() {
        super.init(target: PostAPI.nearbyList(page: 1), pagesize: 20)
    }
}

struct NearPostView: View {
    @StateObject var vm: NearPostViewModel = .init()
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
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { post in
                    PostView(post)
                } loadingView: {
                    PostListLoadingView()
                } emptyView: {
                    XMEmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }

            })
            .padding(.all,16)
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
            }
        }
        .scrollIndicators(.hidden)
        .refreshable { await vm.getListData() }
    }
}

#Preview {
    NearRankView()
        .environmentObject(RankViewModel())
}
