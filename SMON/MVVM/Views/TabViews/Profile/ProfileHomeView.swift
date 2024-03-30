//
//  ProfileHomeView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

struct HomePageInfo : Convertible{
    var userId : String = "" // : 1764610746026688512,
    var isDailySignin : String = "" //": 0,
    var eachFollowNums : String = "" //": 1,
    var currentRank : String = "" //": 4,
    var flamesNums : String = "" //": 0,
    var coinNums : String = "" //": 0
}

class ProfileHomeViewModel: XMModRequestViewModel<HomePageInfo> {
    init() {
        super.init(autoGetData: true, pageName: "") {
            UserAPI.getHomePage
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
        .task {
            await UserManager.shared.getUserInfo()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                XMDesgin.XMButton {
                    MainViewModel.shared.pathPages.append(MainViewModel.PagePath.notification)
                } label: {
                    XMDesgin.XMIcon(iconName: "home_bell")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMButton {
                    MainViewModel.shared.pathPages.append(MainViewModel.PagePath.setting)
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
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profile(userId: UserManager.shared.user.userId))
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
                        .trim(from: 0.0, to: CGFloat(userManager.user.profileCompletionScore ))
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
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profileEditView)
            }
        })
    }

    var banner: some View {
        VStack(alignment: .leading, spacing: 16, content: {
//            Text("免费获取赛币").font(.title3.bold())
            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 4, content: {
                    Text("每日签到")
                        .font(.XMFont.f1b)
                    Text("1次 / 24小时")
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
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }

    var list: some View {
        VStack(alignment: .leading, spacing: 24, content: {
            XMDesgin.XMListRow(.init(name: "互相关注", icon: "profile_friend", subline: "\(vm.mod.eachFollowNums)")) {
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.myfriends)
            }

            XMDesgin.XMListRow(.init(name: "我的当前排名", icon: "profile_fire", subline: "No.\(vm.mod.currentRank)")) {
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.myhotinfo)
            }

            XMDesgin.XMListRow(.init(name: "赛币商店", icon: "home_shop", subline: "限时特惠")) {
                Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop)
            }

        })
        .padding(.vertical, 16)
    }

    var userbackpack: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            VStack(alignment: .center, spacing: 12, content: {
                Text("🔥")
                    .font(.XMFont.big3)
                    .frame(width: 24, height: 24)
                Text("\(vm.mod.flamesNums) 火苗")
                    .font(.XMFont.f1b)
            })
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.XMDesgin.b1)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .center, spacing: 12, content: {
                Image("saicoin_lvl1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("\(vm.mod.flamesNums) 赛币")
                    .font(.XMFont.f1b)
            })
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.XMDesgin.b1)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .profile))
}
