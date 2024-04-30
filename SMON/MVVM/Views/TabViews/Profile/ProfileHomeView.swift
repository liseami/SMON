//
//  ProfileHomeView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import StoreKit
import SwiftUI

struct HomePageInfo: Convertible {
    var userId: String = "" // : 1764610746026688512,
    var isDailySignin: Bool = false // ": 0,
    var eachFollowNums: String = "" // ": 1,
    var currentRank: String = "" // ": 4,
    var flamesNums: String = "" // ": 0,
    var coinNums: String = "" // ": 0
    var currentHot: String = ""
}

class ProfileHomeViewModel: XMModRequestViewModel<HomePageInfo> {
    init() {
        super.init(autoGetData: true, pageName: "") {
            UserAPI.getHomePage
        }
    }

    /*
     每日签到
     */
    @Published var flameJump: Int = 0
    @MainActor func dailySignIn() async {
        let t = AppOperationAPI.dailySignIn
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            await self.getSingleData()
            self.flameJump += 1
            Apphelper.shared.pushNotification(type: .success(message: "🔥 火苗已到账！"))
        }
    }
}

struct ProfileHomeView: View {
    @StateObject var vm: ProfileHomeViewModel = .init()
    @ObservedObject var userManager: UserManager = .shared
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 24, content: {
                // 头像
                avatar
                // 营销活动海报
                banner
                // 导航list
                list
                // 用户背包
                userbackpack
                // 可以滑动更多
                Spacer().frame(height: 120)
            })
            .padding(.horizontal, 16)
        }
        .overlay(alignment: .top, content: {
            // 顶部模糊
            XMTopBlurView()
        })
        .navigationBarTitleDisplayMode(.inline)
        // 购买成功
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.IAP_BUY_SUCCESS, object: nil)) { _ in
            Task {
                await vm.getSingleData()
            }
        }
        .refreshable(action: {
            await vm.getSingleData()
            await UserManager.shared.getUserInfo()
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    MyCoinView()
                        .environmentObject(vm)
                } label: {
                    HStack {
                        Image("saicoin")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(vm.mod.coinNums)
                            .font(.XMFont.f3b)
                            .fcolor(.XMDesgin.f1)
                    }
                    .padding(.horizontal, 4)
                    .padding(.all, 5)
                    .background(Color.XMDesgin.b1)
                    .clipShape(Capsule())
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMButton {
                    MainViewModel.shared.pushTo(MainViewModel.PagePath.setting)
                } label: {
                    XMDesgin.XMIcon(iconName: "profile_setting")
                }
            }
        }
    }

    var avatar: some View {
        VStack(alignment: .center, spacing: 32, content: {
            Text(userManager.user.nickname)
                .font(.title2.bold())
            XMDesgin.XMButton(action: {
                MainViewModel.shared.pushTo(MainViewModel.PagePath.profile(userId: userManager.user.userId))
            }, label: {
                XMUserAvatar(str: userManager.user.avatar, userId: userManager.user.userId, size: 120)
            })
            .overlay {
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: CGFloat(1))
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .fcolor(.XMDesgin.b1)
                        .frame(width: 140, height: 140)
                        .rotationEffect(Angle(degrees: -90))
                    Circle()
                        .trim(from: 0.0, to: CGFloat(userManager.user.profileCompletionScore))
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .fcolor(.XMDesgin.main)
                        .frame(width: 140, height: 140)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.spring(), value: userManager.user.profileCompletionScore)
                }
                .overlay(alignment: .bottom) {
                    Text("\(Int(userManager.user.profileCompletionScore * 100))%")
                        .bold()
                        .fcolor(.XMDesgin.f1)
                        .padding(.all, 4)
                        .padding(.horizontal, 4)
                        .background(Capsule().fcolor(.XMDesgin.main))
                        .overlay(
                            Capsule()
                                .stroke(Color.black, lineWidth: 4) // 红色描边
                        )
                        .offset(x: 0, y: 12)
                        .ifshow(show: userManager.user.profileCompletionScore < 1)
                }
            }

            let text = userManager.user.profileCompletionScore == 1 ? "修改主页资料" : "完成你的主页资料"
            XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "profile_edit", text: text) {
                MainViewModel.shared.pushTo(MainViewModel.PagePath.profileEditView)
            }
        })
    }

    var banner: some View {
        VStack(alignment: .leading, spacing: 16, content: {
//            Text("免费获取赛币").font(.title3.bold())
            XMDesgin.XMButton {
                await vm.dailySignIn()
            } label: {
                HStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 4, content: {
                        Text("每日签到")
                            .font(.XMFont.f1b)
                        Text(vm.mod.isDailySignin ? "今日已签，100火苗已到账" : "1次 / 24小时")
                            .font(.XMFont.f2)
                            .fcolor(.XMDesgin.f2)
                    })
                    .padding(.leading, 120)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(.XMDesgin.b1)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .leading) {
                    Image("profile_calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .scaleEffect(2.2)
                        .padding(.leading, 24)
                }
            }
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }

    var list: some View {
        let listItems = [
            (name: "互相关注", icon: "profile_friend", subline: "\(vm.mod.eachFollowNums)", action: { MainViewModel.shared.pushTo(MainViewModel.PagePath.myfriends) }),
            (name: "我的当前排名", icon: "profile_fire", subline: "No.\(vm.mod.currentRank)", action: { MainViewModel.shared.pushTo(MainViewModel.PagePath.myhotinfo) }),
            (name: "赛币商店", icon: "home_shop", subline: "限时特惠", action: { Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop) }),
            (name: "微信号解锁管理", icon: "inforequest_wechat", subline: "口令码隐私保护", action: { Apphelper.shared.presentPanSheet(SocialAccountView(), style: .shop) })
        ]

        return VStack(alignment: .leading, spacing: 24) {
            ForEach(listItems, id: \.name) { item in
                XMDesgin.XMListRow(.init(name: item.name, icon: item.icon, subline: item.subline)) {
                    item.action()
                }
            }
        }
        .padding(.vertical, 16)
    }

    var userbackpack: some View {
        VStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 12, content: {
                ForEach([
                    (icon: "❤️‍🔥", label: "热度", value: String(format: "%.2f", vm.mod.currentHot.double() ?? 0)),
                    (icon: "🔥", label: "火苗", value: vm.mod.flamesNums)
                ], id: \.icon) { item in
                    XMDesgin.XMButton.init {
                        if item.label == "火苗" {
                            MainViewModel.shared.pushTo(MainViewModel.PagePath.flamedetail)
                        } else {
                            MainViewModel.shared.pushTo(MainViewModel.PagePath.myhotinfo)
                        }
                    } label: {
                        VStack(alignment: .center, spacing: 12) {
                            Text(item.icon)
                                .font(.XMFont.big3)
                                .frame(width: 24, height: 24)
                            Text("\(item.value) \(item.label)")
                                .font(.XMFont.f1b)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.XMDesgin.b1)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .changeEffect(.glow, value: vm.flameJump, isEnabled: item.label == "火苗")
                    .changeEffect(.jump(height: 32), value: vm.flameJump, isEnabled: item.label == "火苗")
                    .conditionalEffect(.repeat(.glow, every: 3), condition: vm.flameJump > 0)
                }
            })
            .overlay(alignment: .center) {
                AutoLottieView(lottieFliesName: "buyhot_arrow", loopMode: .loop, speed: 1.618)
                    .frame(width: 100, height: 100)
                    .scaleEffect(2)
                    .rotationEffect(.init(degrees: 90))
                    .allowsTightening(false)
                    .disabled(true)
            }

            XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "system_toggle", text: "立即兑换为热度") {
                Apphelper.shared.presentPanSheet(HotExchangeView()
                    .environmentObject(vm),
                    style: .sheet)
            }
        }
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .profile))
}
