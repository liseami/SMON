//
//  MyHotInfoView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

class MyHotInfoViewModel : XMModRequestViewModel<UserRankInfo> {
    init() {
        super.init(pageName: "") {
            UserAssetAPI.hotInfo
        }
    }
}

struct UserRankInfo : Convertible {
    let userId: String = ""
    let countryRank: String = ""
    let cityRank: String = ""
    let cityRankDesc: String = ""
    let hotStatus: Int = 0
    let hotTitle: String = ""
    let hotStatusDesc: String = ""
    let hotEventRuleList: [HotEventRule] = []
}

struct HotEventRule :Convertible{
    let title: String = ""
    let hotDesc: String = ""
}

struct MyHotInfoView: View {
    @StateObject var vm : MyHotInfoViewModel = .init()


    var body: some View {
        List {
            if vm.mod.cityRank.isEmpty == false {
                // 全国排名部分
                Section {
                    RankingView(ranking: "No.\(vm.mod.countryRank)")
                        .listRowSeparator(.hidden, edges: .top)
                } header: {
                    Text("全国排名")
                        .font(.XMFont.f1b)
                        .fcolor(.XMColor.f1)
                        .listRowSeparator(.hidden, edges: .all)
                }

                // 同城排名部分
                Section {
                    RankingView(ranking: "No.\(vm.mod.cityRank)")
                        .listRowSeparator(.hidden, edges: .top)
                } header: {
                    Text("同城排名")
                        .font(.XMFont.f1b)
                        .fcolor(.XMColor.f1)
                        .listRowSeparator(.hidden, edges: .all)
                } footer: {
                    XMTyperText(text: "*\(vm.mod.cityRankDesc)")
                        .font(.XMFont.f2)
                        .fcolor(.XMColor.f2)
                        .listRowSeparator(.hidden, edges: .bottom)
                }
            }

            // 当前状态部分
            Section {
                XMDesgin.XMTag(text: vm.mod.hotTitle)
                    .listRowSeparator(.hidden, edges: .top)
            } header: {
                Text("当前状态")
                    .font(.XMFont.f1b)
                    .fcolor(.XMColor.f1)
            } footer: {
                Text("* \(vm.mod.hotStatusDesc)")
                    .font(.XMFont.f2)
                    .fcolor(.XMColor.f2)
                    .listRowSeparator(.hidden, edges: .bottom)
            }

            // 奖励规则部分
            Section {
                RewardsView(rules: vm.mod.hotEventRuleList)
                    .listRowSeparator(.hidden, edges: .top)
            } header: {
                Text("当前规则")
                    .font(.XMFont.f1b)
                    .fcolor(.XMColor.f1)
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
                            .fcolor(.XMColor.f1)
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
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.XMColor.main.gradient.shadow(.drop(color: .XMColor.main, radius: 10)))
            .mask(alignment: .leading) {
                XMTyperText(text: ranking)
                    .font(.custom("GenSekiGothicTW-B", fixedSize: 44))
                    .fcolor(.XMColor.f1)
                    .listRowSeparator(.hidden, edges: .top)
            }
    }
}

// 奖励规则视图
struct RewardsView: View {
    let rules : [HotEventRule]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(rules, id: \.title) { rule in
                RewardRow(title: rule.title, points: rule.hotDesc)
            }
        }
        .fcolor(.XMColor.f2)
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
                .fcolor(.XMColor.f3)

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
