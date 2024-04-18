//
//  HotBuyView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/29.
//

import SwiftUI

class HotBuyViewModel: ObservableObject {
    var tips: [LabelInfo] =
        [.init(name: "动态被点赞、收到礼物、每日登陆都可以获得❤️‍🔥！当然，冲榜是最🚀的选择。", icon: "firebuy_search", subline: ""),
         .init(name: "当你的火苗超过下方选手，就会立刻出现在对应的位置上。", icon: "firebuy_add", subline: ""),
         .init(name: "6小时之内，将受到热度保护。尽情享受人气大爆发的感觉。", icon: "firebuy_care", subline: "")]

    @MainActor
    func buyHot() async {
        guard let _ = input.int else {
            Apphelper.shared.pushNotification(type: .error(message: "只能输入纯数字！"))
            return
        }
    }

    @Published var input: String = ""
}

struct HotBuyView: View {
    @StateObject var vm: HotBuyViewModel = .init()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24, content: {
                // 标题
                header
                // 输入赛币
                inputBar
                // 实时计算，比例
                tag
                Divider()
                // 当前规则
                guize
                Divider()
                // 当前比赛情况
                currentRankInfo
            })
            .padding(.all)
            .padding(.top, 12)
        }
        .background(
            Color.black.ignoresSafeArea()
        )
        .onChange(of: vm.input) { input in
            if input.count > 7 {
                var value = vm.input
                value.removeLast()
                vm.input = value
            }
        }
    }

    var header: some View {
        HStack(alignment: .center, spacing: 12, content: {
            Image("saicoin_lvl1")
                .resizable()
                .scaledToFit()
                .frame(width: 99)
                // 变到榜单时，jump
                .changeEffect(.spray(origin: .bottom) {
                    Group {
                        Text("❤️‍🔥")
                        Text("🔥")
                    }
                    .font(.title)
                }, value: vm.input)
            Text("为自己添加❤️‍🔥，立刻迎来人气大爆发")
                .font(.XMFont.big2.bold())
                .animation(.spring)

        })
    }

    var inputBar: some View {
        HStack {
            HStack {
                Image("saicoin")
                    .resizable()
                    .frame(width: 20, height: 20)
                TextField(text: $vm.input, prompt: Text("输入你要消耗的赛币")) {}
                    .tint(Color.XMDesgin.main)
                    .keyboardType(.numberPad)
                    .font(.XMFont.big3.bold())
            }
            .height(44)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 12)
            .background(Color.XMDesgin.b1)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1.5)
                    .fcolor(.XMDesgin.f1)
            }
            XMDesgin.XMButton {
                Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop)
            } label: {
                Text("立刻冲榜")
                    .width(120)
                    .height(44)
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.b1)
                    .background(Color.XMDesgin.f1)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    var tag: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 4) {
                Image("saicoin")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("\(vm.input.int ?? 1)赛币  =  ❤️‍🔥\((vm.input.int ?? 1) * 100)热度")
            }
            .font(.XMFont.f2b)
            .fcolor(.XMDesgin.f1)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.XMDesgin.b1)
            .clipShape(Capsule())

            HStack(alignment: .center, spacing: 4) {
                XMDesgin.XMIcon(iconName: "system_chart")
                Text("当前比例 1 : 100")
            }
            .font(.XMFont.f2b)
            .fcolor(.XMDesgin.f1)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.XMDesgin.b1)
            .clipShape(Capsule())
        }
    }

    var guize: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            HStack(content: {
                Text("参与方式").font(.XMFont.big3.bold())
                XMDesgin.XMIcon(iconName: "firebuy_ask")
            })
            ForEach(vm.tips, id: \.self.name) { tips in
                HStack(spacing: 12) {
                    XMDesgin.XMIcon(iconName: tips.icon)
                    Text(tips.name)
                        .lineSpacing(4)
                        .font(.XMFont.f2)
                        .fcolor(.XMDesgin.f1)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.XMDesgin.b1)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        })
    }

    var currentRankInfo: some View {
        LazyVStack(alignment: .leading, spacing: 16, content: {
            Text("当前比赛情况").font(.XMFont.big3.bold())
            ForEach(1 ... 12, id: \.self) { pageIndex in
                Text("第\(pageIndex)屏")
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(0 ... 12, id: \.self) { sectionIndex in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                LazyVGrid(columns: Array(repeating: GridItem(.fixed(6), spacing: 1, alignment: .center), count: 3), alignment: .center, spacing: 1, pinnedViews: [], content: {
                                    ForEach(0 ... 11, id: \.self) { index in

                                        Circle()
                                            .frame(width: 6, height: 6, alignment: .center)
                                            .foregroundStyle(sectionIndex == index ? Color.XMDesgin.main : Color.XMDesgin.f1)
                                    }
                                })
                                .frame(width: 32)
                                Text(String.randomChineseString(length: 6))
                                    .lineLimit(1)
                                    .font(.XMFont.f2)
                                    .fcolor(.XMDesgin.f1)
                                Spacer()
                                Text("\(Int.random(in: 0 ... 1200))" + "❤️‍🔥")
                                    .lineLimit(1)
                                    .font(.XMFont.f2)
                                    .fcolor(.XMDesgin.f1)
                            }
                            .height(44)
                            Divider()
                        }
                    }
                }
            }
        })
    }
}

#Preview {
    MainView()
        .onAppear(perform: {
            Apphelper.shared.presentPanSheet(HotBuyView(), style: .setting)
        })
}
