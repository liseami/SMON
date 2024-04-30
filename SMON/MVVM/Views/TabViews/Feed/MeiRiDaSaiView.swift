//
//  CompetitionView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import StoreKit
import SwiftUI
import UserNotifications

class MeiRiDaSaiViewModel: XMListViewModel<XMPost> {
    init() {
        self.sex = UserManager.shared.user.sex == 1 ? 2 : 1
        super.init(target: PostAPI.themeList(p: .init(page: 1, pageSize: 20, type: 0, themeId: 0)), pagesize: 20)
        Task {
            await self.getthemeList()
            await self.refreshPostList()
        }
    }

    deinit {
        PostThemeStore.shared.reset()
    }

    @Published var sex: Int = 1

    // 主题列表
    @Published var themeList: [XMTheme] = [] {
        didSet {
            guard oldValue.isEmpty else { return }
            currentThemeIndex = max(0, themeList.count - 2)
        }
    }

    // 当前主题IndexId
    @Published var currentThemeIndex: Int = 0 {
        // 每次主题变化，请求帖子
        didSet {
            Task {
                await refreshPostList()
            }
        }
    }

    // 当前选择的主题
    var currentTheme: XMTheme? {
        guard !themeList.isEmpty else { return nil }
        PostThemeStore.shared.targetTheme = themeList[currentThemeIndex]
        return themeList[currentThemeIndex]
    }

    // 最热最新
    @Published var themeType: Int = 1 {
        didSet {
            Task {
                await refreshPostList()
            }
        }
    }

    /*
     刷新帖子
     */
    @MainActor
    func refreshPostList() async {
        guard !themeList.isEmpty, let currentTheme else { return }
        target = PostAPI.themeList(p: .init(page: 1, pageSize: 20, type: themeType, themeId: currentTheme.id))
        await getListData()
    }

    /*
     获取主题列表
     */
    @MainActor
    func getthemeList() async {
        themeList = []
        let t = PostsOperationAPI.themeList(page: 1, sex: sex)
        let r = await Networking.request_async(t)
        if r.is2000Ok, let list = r.mapArray(XMTheme.self) {
            themeList = list
            PostThemeStore.shared.themeList = themeList
        }
    }

    /*
     更换大赛性别
     */

    @MainActor
    func changeThemeSex() async {
        sex = sex == 1 ? 2 : 1
        themeList.removeAll()
        await waitme(sec: 0.5)
        await getthemeList()
    }
}

struct MeiRiDaSaiView: View {
    @State var currentIndex: Int = 0
    @StateObject var vm: MeiRiDaSaiViewModel = .init()
    @Environment(\.requestReview) var requestReview
    private let date = Date()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                header
                // 最新最热选择
                tab
                // 帖子列表
                XMStateView(vm.list,
                            reqStatus: vm.reqStatus,
                            loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { post in
                    PostView(post)
                } loadingView: {
                    PostListLoadingView()
                } emptyView: {
                    VStack(spacing: 24) {
                        Text("暂无帖子，快快发布吧！")
                            .font(.XMFont.f1)
                            .fcolor(.XMDesgin.f2)
                        LoadingPostView()
                    }
                    .padding(.top, 12)
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }
            })
            .padding(.all, 16)
            // 请求通知权限 | 3秒后 | 没有请求过的话 authorizationStatus == .notDetermined
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        if settings.authorizationStatus == .notDetermined {
                            DispatchQueue.main.async {
                                Apphelper.shared.presentPanSheet(NotificationRequestView(), style: .setting)
                            }
                        }
                    }
                }
            })
        }
        .refreshable {
            await vm.refreshPostList()
        }
        // 帖子发布成功，刷新列表
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.POST_PUBLISHED_SUCCESS, object: nil)) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                Task {
                    await self.vm.getListData()
                }
            }
            // 发布帖子成功，请求用户评价我们的app，每个用户只请求一次
            requestReview()
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
        if let theme = vm.currentTheme,!vm.themeList.isEmpty {
            VStack(alignment: .center, spacing: 12, content: {
                VStack(alignment: .center, spacing: 16, content: {
                    Text(theme.title)
                        .font(.XMFont.big3.bold())
                        .fcolor(.XMDesgin.f1)

                    Text(theme.description)
                        .lineSpacing(4)
                        .font(.XMFont.f2)
                        .fcolor(.XMDesgin.f1)
                    XMDesgin.XMMainBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: self.vm.sex == 2 ? "去男生主题发帖" : "去女生主题发帖") {
                        await vm.changeThemeSex()
                    }
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
                .frame(maxWidth: .infinity)
                .background {
                    if #available(iOS 17.0, *) {
                        ZStack{
                           
                            TimelineView(.animation) {
                                let time = date.timeIntervalSince1970 - $0.date.timeIntervalSince1970
                                Rectangle()
                                    .aspectRatio(1, contentMode: .fill)
                                    .colorEffect(ShaderLibrary.lightspeed(
                                        .boundingRect,
                                        .float(time),
                                        .float(150),
                                        .float(80),
                                        .float(45)
                                    ))
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .opacity(1)
                        }
                        .overlay(LinearGradient(colors: [Color.XMDesgin.b1,Color.XMDesgin.b1,Color.clear], startPoint: .bottom, endPoint: .top))
                    }
//                    Group{
//                        if #available(iOS 17.0, *) {
//                            TimelineView(.animation) {
//                                let time = date.timeIntervalSince1970 - $0.date.timeIntervalSince1970
//                                Rectangle()
//                                    .aspectRatio(1, contentMode: .fill)
//                                    .colorEffect(ShaderLibrary.lightspeed(
//                                        .boundingRect,
//                                        .float(time),
//                                        .float(150),
//                                        .float(80),
//                                        .float(45)
//                                    ))
//                            }
//                            .frame(maxWidth: .infinity, alignment: .center)
//                        } else {
//                            Color.XMDesgin.b1.gradient
//                        }
//                    }
                }
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
            .transition(.movingParts.anvil.animation(.bouncy))
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
