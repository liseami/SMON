//
//  CompetitionView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import SwiftUI

struct CompetitionView: View {
    @State var currentIndex : Int = 0
    let comps: [XMCompetition] = [
        .init(id: "1", movieTitle: "包臀裙大赛", artwork: "", date: .now),
        .init(id: "2", movieTitle: "小短裙大赛", artwork: "", date: .now),
        .init(id: "3", movieTitle: "护士服大赛", artwork: "", date: .now),
        .init(id: "4", movieTitle: "黑丝袜大赛", artwork: "", date: .now),
        .init(id: "5", movieTitle: "小内裤大赛", artwork: "", date: .now),
        .init(id: "6", movieTitle: "会好吗大赛", artwork: "", date: .now)
    ]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                header
                tab
                postList
            })
            .padding(.all, 16)
        }
    }

    @ViewBuilder
    var postList: some View {
        ForEach(0 ... 23, id: \.self) { _ in
            PostView()
        }
    }

    var tab: some View {
        HStack {
            Text("热门")
                .font(.XMFont.f1b)
                .foregroundStyle(Color.XMDesgin.b1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(Color.XMDesgin.f1)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text("最新")
                .font(.XMFont.f1b)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 4)
        .background(Color.XMDesgin.b1)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    var header: some View {
        VStack(alignment: .center, spacing: 12, content: {
            VStack(alignment: .center, spacing: 16, content: {
                Text("包臀裙大赛")
                    .font(.XMFont.big2.bold())
                    .fcolor(.XMDesgin.f1)
                XMDesgin.SmallBtn(fColor: .XMDesgin.main, backColor: .XMDesgin.b1, iconName: "system_toggle", text: "切换至男生主题") {}
                    .padding(.vertical, -12)
                Text("快来秀出你的包臀裙照片吧，快来秀出你的包臀裙照片吧，快来秀出你的包臀裙照片吧。")
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f1)
                    
                XMDesgin.XMMainBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "立即参与发帖") {}
                    .overlay(alignment: .center) {
                        Capsule().stroke(lineWidth: 2)
                            .fcolor(.XMDesgin.f2)
                    }
                HStack {
                    Text("23992人参与 · ")
                    Text("3天后截止")
                }
                .font(.XMFont.f2).monospaced()
                .fcolor(.XMDesgin.f2)
            })
            .padding(.top, 68)
            .padding(.all, 16)
            .background(Color.XMDesgin.b1)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .top) {
                // Carousel List...
                SnapCarousel(spacing: 12, trailingSpace: 200, index: $currentIndex, items: comps, content: { comp in
                    headerImage
                })
                .offset(x: 0, y: -30)
            }
        })
        .padding(.top, 40)
    }

    var headerImage: some View {
        WebImage(str: AppConfig.mokImage!.absoluteString)
            .frame(width: 156, height: 156 / 16 * 9)
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 3)
                    .fcolor(.XMDesgin.f1)
            }
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .feed))
}
