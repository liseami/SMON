//
//  CompetitionView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import SwiftUI

class MeiRiDaSaiViewModel: ObservableObject {
    @Published var postList: [XMPost] = []
    // 当前主题IndexId
    @Published var currentThemeIndex: Int = 0

    // 主题列表
    @Published var themeList: [XMTheme] = []

    // 最热最新
    @Published var themeType: Int = 1 {
        didSet {
            Task { await self.getthemeList() }
        }
    }

    init() {
        Task { await self.getthemeList() }
    }

    // 当前选择的主题
    var currentTheme: XMTheme? {
        guard !themeList.isEmpty else { return nil }
        return themeList[currentThemeIndex]
    }

    /*
     获取主题列表
     */
    @MainActor
    func getthemeList() async {
        themeList = []
        let t = PostsOperationAPI.themeList(p: .init())
        let r = await Networking.request_async(t)
        if r.is2000Ok, let list = r.mapArray(XMTheme.self) {
            themeList = list
        }
    }
}

struct MeiRiDaSaiView: View {
    @State var currentIndex: Int = 0
    @StateObject var vm: MeiRiDaSaiViewModel = .init()

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                header
//                // 最新最热选择
                tab
                // 帖子列表
                if let themeid = vm.currentTheme?.id {
                    CompetitionPostListView(type: vm.themeType, themeId: themeid)
                        .environmentObject(vm)
                }
            })
            .padding(.all, 16)
        }
        .refreshable {
            await vm.getthemeList()
        }
    }

    var tab: some View {
        HStack {
            ForEach(1 ... 2, id: \.self) { themetype in
                let selected = vm.themeType == themetype
                let text = themetype == 1 ? "最热" : "最新"
                XMDesgin.XMButton {
                    vm.themeType = themetype
                } label: {
                    Text(text)
                        .font(selected ? .XMFont.f1b : .XMFont.f1)
                        .fcolor(Color.XMDesgin.f1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(selected ? Color.XMDesgin.b1 : Color.XMDesgin.b1.opacity(0.01))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 4)
        .background(Color.XMDesgin.b1.opacity(0))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    var header: some View {
        if let theme = vm.currentTheme {
            VStack(alignment: .center, spacing: 12, content: {
                VStack(alignment: .center, spacing: 16, content: {
                    Text(theme.title)
                        .font(.XMFont.big3.bold())
                        .fcolor(.XMDesgin.f1)

                    Text(theme.description)
                        .font(.XMFont.f2)
                        .fcolor(.XMDesgin.f1)

                    XMDesgin.XMMainBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "去男生主题发帖") {}
                        .overlay(alignment: .center) {
                            Capsule()
                                .stroke(lineWidth: 1)
                                .fcolor(.XMDesgin.f2)
                        }
                    HStack(spacing: 0) {
                        Text("\(theme.postsNums)个帖子 · ")
                        // xx天后截止
                        Text(theme.deadlineInfoStr)
                    }
                    .font(.XMFont.f2).monospaced()
                    .fcolor(.XMDesgin.f2)
                })
                .padding(.top, 68)
                .padding(.all, 16)
                .background(Color.XMDesgin.b1.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .top) {
                    // 主题大赛列表
                    BannerRow(imageW: 156, spacing: 12, index: $vm.currentThemeIndex, list: vm.themeList) { theme in
                        headerImage(theme.coverUrl)
                    }
                    .offset(x: 0, y: -44)
                }
            })
            .padding(.top, 40)
        } else {
            fakeheader
        }
    }

    var fakeheader: some View {
        VStack(alignment: .center, spacing: 12, content: {
            VStack(alignment: .center, spacing: 16, content: {
                Text("theme.title")
                    .redacted(reason: .placeholder)
                    .font(.XMFont.big3.bold())
                    .fcolor(.XMDesgin.f1)
                Text("theme.description")
                    .redacted(reason: .placeholder)
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f1)

                XMDesgin.XMMainBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "正在寻找大赛主题") {}
                    .overlay(alignment: .center) {
                        Capsule()
                            .stroke(lineWidth: 1)
                            .fcolor(.XMDesgin.f2)
                    }
                HStack(spacing: 0) {
                    Text("232345个帖子 · ")
                        .redacted(reason: .placeholder)
                    // xx天后截止
                    Text("theme.deadlineInfoStr")
                        .redacted(reason: .placeholder)
                }
                .font(.XMFont.f2).monospaced()
                .fcolor(.XMDesgin.f2)
            })
            .padding(.top, 68)
            .padding(.all, 16)
            .background(Color.XMDesgin.b1.gradient)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .top) {
                // 主题大赛列表
                BannerRow(imageW: 156, spacing: 12, index: .constant(2), list: [XMTheme(id: 1), XMTheme(id: 2), XMTheme(id: 3), XMTheme(id: 4), XMTheme(id: 5), XMTheme(id: 6)]) { _ in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.XMDesgin.b1)
                        .scaledToFill()
                        .frame(width: 156, height: 156 / 16 * 9)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: .center) {
                            RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 3)
                                .fcolor(.XMDesgin.f1)
                        }
                        .conditionalEffect(.repeat(.shine, every: 1), condition: true)
                }
                .offset(x: 0, y: -44)
            }
        })
        .padding(.top, 40)
    }

    func headerImage(_ imageUrl: String) -> some View {
        WebImage(str: imageUrl)
            .scaledToFill()
            .frame(width: 156, height: 156 / 16 * 9)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 3)
                    .fcolor(.XMDesgin.f1)
            }
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .feed))
        .environmentObject(FeedViewModel())
}
