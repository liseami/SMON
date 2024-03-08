//
//  CompetitionView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import SwiftUI

struct CompetitionView: View {
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
                    .font(.XMFont.f1b)
                    .fcolor(.XMDesgin.f1)
                XMDesgin.SmallBtn(fColor: .XMDesgin.main, backColor: .XMDesgin.b1, iconName: "system_toggle", text: "切换至男生主题") {}
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
            .padding(.top, 48)
            .padding(.all, 16)
            .background(Color.XMDesgin.b1)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .top) {
                HStack {
                    headerImage
                        .rotation3DEffect(.degrees(30), axis: .y, anchor: .center, anchorZ: -0.6, perspective: -0.5)
                        .scaleEffect(CGSize(width: 0.9, height: 0.8), anchor: .trailing)
                    headerImage
                    headerImage
                        .rotation3DEffect(.degrees(30), axis: .y, anchor: .center, anchorZ: 0.6, perspective: 0.5)
                        .scaleEffect(CGSize(width: 0.9, height: 0.8), anchor: .leading)
                }
                .offset(x: 0, y: -50)
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
