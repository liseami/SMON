//
//  MyHotInfoView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

struct MyHotInfoView: View {
    // 定义奖励规则数组
    let rewards = [
        ("发布的动态被点赞、评论", "+ 10 🔥"),
        ("收到礼物", "+ 礼物赛币价值 * 10 🔥"),
        ("每日登录", "+ 50 🔥"),
        ("参加大赛", "+ 200 🔥"),
        ("大赛帖子被点赞、评论", "+ 30 🔥"),
        ("朋友填写了你的邀请码", "+ 1000 🔥")
    ]

    var body: some View {
        List {
            // 全国排名部分
            Section {
                RankingView(ranking: "No.2392950335")
            } header: {
                Text("全国排名")
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.f1)
            } footer: {
                XMTyperText(text: "* 通过发布动态、参加主题赛、收获会员们的点赞，来提升热度。或通过直接购买的方式快速为自己升温！")
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f2)
                    .listRowSeparator(.hidden, edges: .bottom)
            }

            // 奖励规则部分
            Section {
                RewardsView(rewards: rewards)
                    .listRowSeparator(.hidden, edges: .top)
            } header: {
                Text("当前规则")
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.f1)
            }

            // 同城排名部分
            Section {
                RankingView(ranking: "No.20320942")
            } header: {
                Text("同城排名")
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.f1)
            }

            // 当前状态部分
            Section {
                XMDesgin.XMTag(text: "❄️一级冷却")
                    .listRowSeparator(.hidden, edges: .top)
            } header: {
                Text("当前状态")
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.f1)
            } footer: {
                Text("* 进入全国前300后，你会拥有6个小时的热度保护期。之后，你会开始慢慢降温，以给其他人曝光的机会。但可以通过主动购买热度的方式，让自己重新进入6个小时的保护期！")
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f2)
                    .listRowSeparator(.hidden, edges: .bottom)
            }
        }
        .listStyle(.plain)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    HotHistoryView()
                } label: {
                    HStack {
                        XMDesgin.XMIcon(iconName: "profile_hot_history", withBackCricle: false)
                        Text("明细")
                            .fcolor(.XMDesgin.f1)
                    }
                }
            }
        })
        .navigationTitle("当前热度")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 排名视图
struct RankingView: View {
    let ranking: String

    var body: some View {
        XMTyperText(text: ranking)
            .font(.XMFont.big1)
            .fcolor(.XMDesgin.f1)
            .listRowSeparator(.hidden, edges: .top)
            .padding(.all, 12)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.XMDesgin.main.gradient.shadow(.drop(color: .XMDesgin.main, radius: 10)))
            )
    }
}

// 奖励规则视图
struct RewardsView: View {
    let rewards: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(rewards, id: \.0) { title, points in
                RewardRow(title: title, points: points)
            }
        }
        .fcolor(.XMDesgin.f2)
    }
}

// 奖励规则行视图
struct RewardRow: View {
    let title: String
    let points: String

    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.XMFont.f2)
                .fixedSize(horizontal: true, vertical: false)

            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 3, dash: [3]))
                .frame(maxWidth: .infinity, maxHeight: 2)
                .fcolor(.XMDesgin.f3)

            Text(points)
                .font(.XMFont.f2)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

// 虚线形状
struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: rect.width, y: 1))
        return path
    }
}

#Preview {
    NavigationView(content: {
        MyHotInfoView()
    })
}
