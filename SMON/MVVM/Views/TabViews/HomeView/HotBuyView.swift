//
//  HotBuyView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/29.
//

import SwiftUI
import SwiftUIX

class HotBuyViewModel: ObservableObject {
    var tips: [LabelInfo] =
        [.init(name: "动态被点赞、收到礼物、每日登陆都可以获得❤️‍🔥！当然，冲榜是最🚀的选择。", icon: "firebuy_search", subline: ""),
         .init(name: "当你的火苗超过下方选手，就会立刻出现在对应的位置上。", icon: "firebuy_add", subline: ""),
         .init(name: "6小时之内，将受到热度保护。尽情享受人气大爆发的感觉。", icon: "firebuy_care", subline: "")]
}

struct HotBuyView: View {
    @StateObject var vm: HotBuyViewModel = .init()
    @State var showImage: Bool = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24, content: {
                HStack(alignment: .center, spacing: 12, content: {
                    Image("saicoin_lvl1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 99)
                        .transition(.movingParts.anvil)
                        .ifshow(show: showImage)
                    Text("为自己添加❤️‍🔥,立刻迎来人气大爆发")
                        .font(.XMFont.big2.bold())
                        .animation(.spring)
                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                self.showImage = true
                                Apphelper.shared.mada(style: .heavy)
                            }
                        })
                })

                HStack {
                    HStack {
                        Text("❤️‍🔥")
                        TextField(text: .constant(""), prompt: Text("输入你需要的热度")) {}
                            .tint(Color.XMDesgin.main)
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
                VStack(alignment: .leading, spacing: 12) {
//                    XMDesgin.XMTag(text: "🔥火苗剩余：29294", bgcolor: .XMDesgin.b1)
                    HStack(alignment: .center, spacing: 4) {
                        Image("saicoin")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("1赛币  =  ❤️‍🔥100热度")
                    }
                    .font(.XMFont.f2b)
                    .fcolor(.XMDesgin.f1)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.XMDesgin.b1)
                    .clipShape(Capsule())
                }

                Divider()
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
                Divider()

                VStack(alignment: .leading, spacing: 16, content: {
                    Text("当前比赛情况").font(.XMFont.big3.bold())
                    ForEach(1 ... 12, id: \.self) { pageIndex in
                        Text("第\(pageIndex)屏")
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(0 ... 12, id: \.self) { sectionIndex in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        LazyVGrid(columns: Array(repeating: GridItem(.fixed(6), spacing: 1, alignment: .center), count: 3), alignment: .center, spacing: 1, pinnedViews: [], content: {
                                            ForEach(0 ... 11, id: \.self) { index in

                                                RoundedRectangle(cornerRadius: 1)
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

            })
            .padding(.all)
            .padding(.top, 12)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    MainView()
        .onAppear(perform: {
            Apphelper.shared.presentPanSheet(HotBuyView(), style: .setting)
        })
}
