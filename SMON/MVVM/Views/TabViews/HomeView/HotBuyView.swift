//
//  HotBuyView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/29.
//

import SwiftUI

struct RankInfo: Convertible {
    var coinToHotRatio: Int?
    var userInfoList: [RankUserInfo] = []
    var countDownBySeconds: String = ""
}

struct RankUserInfo: Convertible {
    var userId: String = "" //  1764610746026688512,
    var nickname: String = "" // ": "zhanglu1385",
    var avatar: String = "" // ": "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/avatar/default.jpg",
    var popularity: String = "" // ": 269.8290449039000
}

class HotBuyViewModel: XMModRequestViewModel<RankInfo> {
    init() {
        super.init(pageName: "") {
            RankAPI.currentRankInfo(cityId: nil)
        }
        Task { await self.getSingleData()
            await self.getMyHotInfo()
        }
    }

    @Published var city: Bool = false {
        didSet {
            Task {
                target = city ? RankAPI.currentRankInfo(cityId: UserManager.shared.user.cityId) : RankAPI.currentRankInfo(cityId: nil)
                await self.getSingleData()
            }
        }
    }

    @Published var userHotInfo: HomePageInfo = .init()

    var tips: [LabelInfo] =
        [.init(name: "动态被点赞、收到礼物、每日登陆都可以获得❤️‍🔥！当然，冲榜是最🚀的选择。", icon: "firebuy_search", subline: ""),
         .init(name: "当你的火苗超过下方选手，就会立刻出现在对应的位置上。", icon: "firebuy_add", subline: ""),
         .init(name: "6小时之内，将受到热度保护。尽情享受人气大爆发的感觉。", icon: "firebuy_care", subline: "")]

    @MainActor
    func buyHot() async {
        guard let input = input.int else {
            Apphelper.shared.pushNotification(type: .error(message: "只能输入纯数字！"))
            return
        }
        let t = UserAssetAPI.coinToHot(coin: input)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            Apphelper.shared.pushNotification(type: .success(message: "兑换成功！排名上升了！！"))
            self.input.removeAll()
            await getMyHotInfo()
        } else if r.messageCode == 2002 {
            Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop)
        }
    }

    @MainActor
    func getMyHotInfo() async {
        let t = UserAPI.getHomePage
        let r = await Networking.request_async(t)
        if r.is2000Ok, let info = r.mapObject(HomePageInfo.self) {
            userHotInfo = info
        }
    }

    @Published var input: String = ""

    @Published var timer: Timer?

    func startCountdown(with value: Int) {
        countdown = 0
        timer?.invalidate()
        timer = nil
        countdown = value
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.countdown > 0 {
                    self.countdown -= 1
                } else {
                    // 请求接口
                    Task {
                        self.timer?.invalidate()
                        await self.getSingleData()
                    }
                }
            }
        }
    }

    @Published var countdown: Int = 0
}

struct HotBuyView: View {
    @StateObject var vm: HotBuyViewModel = .init()
    @State private var showTip: Bool = false
    @State private var show: Bool = false
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
        .onAppear(perform: {
            withAnimation {
                show = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.IAP_BUY_SUCCESS, object: nil)) { _ in
            Task {
                await vm.getMyHotInfo()
            }
        }
        .onChange(of: vm.mod.countDownBySeconds, perform: { sec in
            if let sec = sec.int {
                vm.startCountdown(with: sec)
            }
        })
        .scrollDismissesKeyboard(.interactively)
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
            Image("3d-blocks-blocks-composition-69")
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
                .transition(.movingParts.pop(Color.XMColor.main).animation(.bouncy(duration: 1, extraBounce: 0.5)))
                .ifshow(show: show)
            Text("为自己添加热度，立刻迎来人气大爆发")
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
                TextField(text: $vm.input, prompt: Text("投入赛币！")) {}
                    .tint(Color.XMColor.main)
                    .keyboardType(.numberPad)
                    .font(.XMFont.big3.bold())
            }
            .height(44)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 12)
            .background(Color.XMColor.b1)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 1.5)
                    .fcolor(.XMColor.f1)
            }
            XMDesgin.XMButton {
                await vm.buyHot()
            } label: {
                Text("立刻冲榜")
                    .width(120)
                    .height(44)
                    .font(.XMFont.f1b)
                    .fcolor(.XMColor.b1)
                    .background(Color.XMColor.f1)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // 实时热度计算
    var rd: Double {
        Double(vm.input.int ?? 1) * Double(vm.mod.coinToHotRatio ?? 1)
    }

    @ViewBuilder
    var tag: some View {
        XMDesgin.XMButton(action: {
            Apphelper.shared.presentPanSheet(CoinshopView(), style: .shop)
        }, label: {
            VStack(alignment: .leading, spacing: 12) {
                infoView(title: "当前比例", image: "saicoin", value: "\(vm.input.int ?? 1)赛币  =  ❤️‍🔥\(String(format: "%.2f", rd))热度")
                HStack {
                    infoView(title: "可用赛币", image: "saicoin", value: "\(vm.userHotInfo.coinNums)赛币")
                    Text("特惠充值")
                        .font(.XMFont.f2b)
                        .fcolor(.XMColor.main)
                        .padding(.all, 4)
                        .background(Color.XMColor.main.gradient.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                infoView(title: "我的热度", value:
                    String(format: "❤️‍🔥%.2f热度", vm.userHotInfo.currentHot.double() ?? 0.0))
            }
        })
    }

    func infoView(title: String, image: String? = nil, value: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(.XMFont.f2b)

            Group {
                if let imageName = image {
                    HStack(alignment: .center, spacing: 4) {
                        Image(imageName)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(value)
                    }
                } else {
                    Text(value)
                }
            }

            .font(.XMFont.f2b)
            .fcolor(.XMColor.f1)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.XMColor.b1)
            .clipShape(Capsule())
        }
    }

    var guize: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            HStack(content: {
                Text("参与方式").font(.XMFont.big3.bold())
                XMDesgin.XMIcon(iconName: "firebuy_ask")
                    .onTapGesture {
                        showTip.toggle()
                    }
            })
            VStack(alignment: .leading, spacing: 16) {
                ForEach(vm.tips, id: \.self.name) { tips in
                    HStack(spacing: 12) {
                        XMDesgin.XMIcon(iconName: tips.icon)
                        Text(tips.name)
                            .lineSpacing(4)
                            .font(.XMFont.f2)
                            .fcolor(.XMColor.f1)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.XMColor.b1)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .transition(.opacity.combined(with: .movingParts.move(edge: .bottom)))
            .ifshow(show: showTip)
        })
    }

    // 12个一组
    func split<T>(array: [T], groupSize: Int) -> [[T]] {
        return stride(from: 0, to: array.count, by: groupSize).map { start in
            let end = min(start + groupSize, array.count)
            return Array(array[start ..< end])
        }
    }

    var usergroup: [[RankUserInfo]] {
        split(array: vm.mod.userInfoList, groupSize: 12)
    }

    var currentRankInfo: some View {
        LazyVStack(alignment: .leading, spacing: 24, content: {
            HStack(alignment: .center, spacing: 12) {
                Text("当前大赛排位 " + (vm.city ? UserManager.shared.user.cityName : "全国"))
                    .font(.XMFont.big3.bold())
                Menu {
                    Button("全国") {
                        vm.city = false
                    }
                    Button("同城") {
                        vm.city = true
                    }
                    .ifshow(show: !UserManager.shared.user.cityId.isEmpty)
                } label: {
                    XMDesgin.XMIcon(iconName: "system_arrow_right", size: 16, withBackCricle: true)
                        .rotationEffect(.init(degrees: 90))
                }

                Spacer()
                Text("\(vm.countdown)秒 后刷新")
                    .font(.XMFont.f2)
                    .fcolor(.XMColor.f1)
                    .changeEffect(.glow, value: vm.countdown)
            }

            ForEach(usergroup, id: \.first?.userId) { group in
                let group_index = usergroup.firstIndex(where: { $0.first?.userId == group.first?.userId }) ?? 0
                Text("第\(group_index + 1)屏")
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(group, id: \.userId) { user in
                        if let user_index = group.firstIndex(where: { $0.userId == user.userId }) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(6), spacing: 1, alignment: .center), count: 3), alignment: .center, spacing: 1, pinnedViews: [], content: {
                                        ForEach(0 ... 11, id: \.self) { index in
                                            Circle()
                                                .frame(width: 6, height: 6, alignment: .center)
                                                .foregroundStyle(user_index == index ? Color.XMColor.main : Color.XMColor.f1)
                                        }
                                    })
                                    .frame(width: 32)
                                    // 前三名特殊对待
                                    let isSupserUser = group_index == 0 && user_index < 3
                                    XMUserAvatar(str: user.avatar, userId: user.userId, size: 32)
                                        .disabled(true)
                                        .onTapGesture(perform: {
                                            Apphelper.shared.presentPanSheet(ProfileView(userId: user.userId), style: .cloud)
                                        })
                                        .ifshow(show: isSupserUser)
                                    Text(user.nickname)
                                        .lineLimit(1)
                                        .font(.XMFont.f1)
                                        .fcolor(.XMColor.f1)
                                    Spacer()
                                    Text(String(format: "%.2f", Double(user.popularity) ?? 0.00) + "❤️‍🔥")
                                        .lineLimit(1)
                                        .font(.XMFont.f1)
                                        .fcolor(.XMColor.f1)
                                }
                                .height(44)
                                Divider()
                            }
                            .transition(.movingParts.move(edge: .bottom).animation(.bouncy.delay(Double(user_index) * 0.24)))
                        } else {
                            EmptyView()
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
