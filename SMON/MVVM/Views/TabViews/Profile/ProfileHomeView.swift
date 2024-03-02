//
//  ProfileHomeView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

struct ProfileHomeView: View {
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
                Spacer().frame(height: 120)
            })
            .padding(.horizontal, 16)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                XMDesgin.XMButton {
                    MainViewModel.shared.pathPages.append(.notification)
                } label: {
                    XMDesgin.XMIcon(iconName: "home_bell")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMButton {
                    MainViewModel.shared.pathPages.append(.setting)
                } label: {
                    XMDesgin.XMIcon(iconName: "profile_setting")
                }
            }
        }
    }

    var avatar: some View {
        VStack(alignment: .center, spacing: 32, content: {
            Text("赵纯想")
                .font(.title2.bold())
            XMDesgin.XMButton(action: {
                MainViewModel.shared.pathPages.append(.myprofile)
            }, label: {
                AsyncImage(url: URL(string: "https://i.pravatar.cc/1000")!)
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            })
            .overlay {
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: CGFloat(1))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.XMDesgin.b1)
                        .frame(width: 140, height: 140)
                        .rotationEffect(Angle(degrees: -90))
                    Circle()
                        .trim(from: 0.0, to: CGFloat(0.3))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.XMDesgin.main)
                        .frame(width: 140, height: 140)
                        .rotationEffect(Angle(degrees: -90))
                }
                .overlay(alignment: .bottom) {
                    Text("20%")
                        .bold()
                        .foregroundStyle(Color.XMDesgin.f1)
                        .padding(.all, 4)
                        .padding(.horizontal, 4)
                        .background(Capsule().foregroundColor(Color.XMDesgin.main))
                        .overlay(
                            Capsule()
                                .stroke(Color.black, lineWidth: 4) // 红色描边
                        )
                        .offset(x: 0, y: 12)
                }
            }
            XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "profile_edit", text: "完成你的主页资料") {
                MainViewModel.shared.pathPages.append(.profileEditView)
            }
        })
    }

    var banner: some View {
        VStack(alignment: .leading, spacing: 16, content: {
//            Text("免费获取赛币").font(.title3.bold())
            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 4, content: {
                    Text("每日签到").font(.body.bold())
                    Text("1次 / 24小时").font(.subheadline.bold())
                        .foregroundColor(.XMDesgin.f2)
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
            XMDesgin.XMListRow(.init(name: "互相关注", icon: "profile_friend", subline: "32")) {
                MainViewModel.shared.pathPages.append(.myfriends)
            }

            XMDesgin.XMListRow(.init(name: "我的当前排名", icon: "profile_fire", subline: "No.23992")) {
                MainViewModel.shared.pathPages.append(.myhotinfo)
            }

            XMDesgin.XMListRow(.init(name: "赛币商店", icon: "home_shop", subline: "限时特惠")) {
//                vm.pathPages.append(.coinshop)
                Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop)
            }

        })
        .padding(.vertical,16)
    }

    var userbackpack: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 16) {
            VStack(alignment: .center, spacing: 12, content: {
                Text("🔥")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .frame(width: 24, height: 24)
                Text("0 火苗")
                    .font(.body.bold())
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
                Text("0 赛币")
                    .font(.body.bold())
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
