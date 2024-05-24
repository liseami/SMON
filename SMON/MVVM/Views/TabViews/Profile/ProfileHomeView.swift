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
    @StateObject var vipVM: VipPrivilegeManager = .init()

    @StateObject var vm: ProfileHomeViewModel = .init()
    @ObservedObject var userManager: UserManager = .shared
    @State private var show: Bool = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 24, content: {
                // 头像
                avatar
                // 营销活动海报
                banner
                // 用户背包
                userbackpack
                // 导航list
                list
                // 会员卡片
                memberShipCard
                    .ifshow(show: userManager.user.vipLevel == 0)
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
            Task { await vm.getSingleData() }
        }
    
        .refreshable(action: {
            await vm.getSingleData()
            await UserManager.shared.getUserInfo()
        })
        .toolbar {
            toolBar
        }
    }

    @ToolbarContentBuilder
    var toolBar: some ToolbarContent {
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
                        .fcolor(.XMColor.f1)
                }
                .padding(.horizontal, 4)
                .padding(.all, 5)
                .background(Color.XMColor.b1)
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

    var startDate: Date = .now
    var memberShipCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 4, content: {
                Image("saicoin")
                    .resizable()
                    .frame(width: 32, height: 32)
                Text("大赛至尊会员")
                    .font(.XMFont.f1b)
                    .fcolor(.XMColor.f1)
                Spacer()
                XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.main, iconName: "", text: "立刻升级🙋") {
                    Apphelper.shared.present(MemberShipView(), presentationStyle: .fullScreen)
                }
            })
            VStack(alignment: .leading, spacing: 12, content: {
                Text("立即联系你喜欢的人")
                    .font(.XMFont.big1.bold())
                Text("体验我们的核心服务")
                    .font(.XMFont.big1.bold())
                    .fcolor(.XMColor.main)
            })
            HStack(alignment: .center, spacing: 12, content: {
                VStack(alignment: .leading, spacing: 24, content: {
                    Text("功能权限")
                        .font(.XMFont.f1b)
                    ForEach(vipVM.mod.vipAbilityList, id: \.self) { item in
                        Text(item.title)
                    }
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .center, spacing: 24, content: {
                    Text("普通会员")
                        .font(.XMFont.f1b)
                    ForEach(vipVM.mod.vipAbilityList, id: \.self) { item in
                        Text(item.nonVipDesc)
                    }
                })
                VStack(alignment: .center, spacing: 24, content: {
                    Text("至尊会员")
                        .font(.XMFont.f1b)
                    ForEach(vipVM.mod.vipAbilityList, id: \.self) { item in
                        Text(item.vipDesc)
                    }
                })
            })
            .font(.XMFont.f2)
            .fcolor(.XMColor.f1)
            XMDesgin.XMMainBtn(fColor: .XMColor.f1, backColor: .XMColor.main, iconName: "", text: "立刻升级", enable: true) { Apphelper.shared.present(MemberShipView(), presentationStyle: .fullScreen) }
        }
        .padding(.all, 16)
        .background {
            TimelineView(.animation) { context in
                if #available(iOS 17.0, *) {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.white, lineWidth: 3)
                        .colorEffect(
                            ShaderLibrary.default.circleMesh(.boundingRect, .float(context.date.timeIntervalSince1970 - startDate.timeIntervalSince1970))
                        )
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .background(Color.XMColor.b1.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var avatar: some View {
        VStack(alignment: .center, spacing: 32, content: {
            HStack {
                Text(userManager.user.nickname)
                    .font(.title2.bold())
                if userManager.user.vipLevel != 0 {
                    Image("home_vipIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }

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
                        .fcolor(.XMColor.b1)
                        .frame(width: 140, height: 140)
                        .rotationEffect(Angle(degrees: -90))
                    Circle()
                        .trim(from: 0.0, to: CGFloat(userManager.user.profileCompletionScore))
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .fcolor(.XMColor.main)
                        .frame(width: 140, height: 140)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.spring(), value: userManager.user.profileCompletionScore)
                }
                .overlay(alignment: .bottom) {
                    Text("\(Int(userManager.user.profileCompletionScore * 100))%")
                        .bold()
                        .fcolor(.XMColor.f1)
                        .padding(.all, 4)
                        .padding(.horizontal, 4)
                        .background(Capsule().fcolor(.XMColor.main))
                        .overlay(
                            Capsule()
                                .stroke(Color.black, lineWidth: 4) // 红色描边
                        )
                        .offset(x: 0, y: 12)
                        .ifshow(show: userManager.user.profileCompletionScore < 1)
                }
            }

            HStack {
                let text = userManager.user.profileCompletionScore == 1 ? "修改主页资料" : "完成你的主页资料"
                XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.b1, iconName: "profile_edit", text: text) {
                    MainViewModel.shared.pushTo(MainViewModel.PagePath.profileEditView)
                }
                NavigationLink {
                    MyCoinView()
                        .environmentObject(vm)
                } label: {
                    XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.b1, iconName: "profile_wallet", text: "") {}
                        .disabled(true)
                        .allowsTightening(false)
                }
            }
        })
    }

    var banner: some View {
        VStack(alignment: .leading, spacing: 16, content: {
//            Text("免费获取赛币").font(.title3.bold())
            XMDesgin.XMButton {
                await vm.dailySignIn()
            } label: {
                let btn = HStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 4, content: {
                        Text("每日签到")
                            .font(.XMFont.f1b)
                        Text(vm.mod.isDailySignin ? "今日已签，100火苗已到账" : "1次 / 24小时")
                            .font(.XMFont.f2)
                            .fcolor(.XMColor.f2)
                    })
                    .padding(.leading, 120)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(.XMColor.b1)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .leading) {
                    Image("profile_calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .scaleEffect(2.2)
                        .padding(.leading, 24)
                }
                if vm.mod.isDailySignin {
                    btn
                } else {
                    btn
                        .conditionalEffect(.repeat(.shine, every: 1), condition: show)
                }
            }
            .onAppear(perform: {
                show = true
            })
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }

    struct ListItem {
        let name: String
        let icon: String
        let subline: String
        let action: () -> Void
    }

    @ViewBuilder
    var list: some View {
        let listItems: [ListItem] = [
            ListItem(name: "互相关注", icon: "profile_friend", subline: "\(vm.mod.eachFollowNums)", action: { MainViewModel.shared.pushTo(MainViewModel.PagePath.myfriends) }),
            ListItem(name: "实名认证", icon: "system_checkmark", subline: "获得人气爆发", action: {
                Task { MainViewModel.shared.pathPages.append(MainViewModel.PagePath.faceAuth) }
            }),
            ListItem(name: "我的排名", icon: "profile_fire", subline: "No.\(vm.mod.currentRank)", action: { MainViewModel.shared.pushTo(MainViewModel.PagePath.myhotinfo) }),
            ListItem(name: "赛币充值", icon: "home_shop", subline: "限时特惠", action: { Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop) }),
            ListItem(name: "微信号解锁管理", icon: "inforequest_wechat", subline: "口令码+门槛设置", action: { Apphelper.shared.present(SocialAccountView(), presentationStyle: .form) })
        ]

        VStack(alignment: .leading, spacing: 24) {
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
                        .background(Color.XMColor.b1)
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

            XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.b1, iconName: "system_toggle", text: "立即兑换为热度") {
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
