//
//  ProfileView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI
import SwiftUIX
import Tagly

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel
    var userId: String
    
    // 初始化
    init(userId: String) {
        self._vm = StateObject(wrappedValue: .init(userId: userId))
        self.userId = userId
    }
    
    // 用户信息快捷访问
    var userInfo: XMUserProfile {
        vm.user
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                // 顶部图像视图
                topImageView
                // 个人信息视图
                profileInfoView
            }
//            tagView
//                .padding(.horizontal, 16)
            // 标签栏视图
            tabBarView
            // 照片
            LazyVStack(alignment: .leading, spacing: 12) {
                switch vm.currentTab {
                case .media:
                    // 照片墙
                    mediaGridView
                    // 帖子
                    postList
                case .gift:
                    EmptyView()
//                case .rank:
//                    VStack(alignment: .leading, spacing: 32) {
//                        // 全国排名部分
//                        Text("全国排名")
//                            .font(.XMFont.f1b)
//                            .fcolor(.XMDesgin.f1)
//                        RankingView(ranking: "No.\(1231)")
//
//                        Text("同城排名")
//                            .font(.XMFont.f1b)
//                            .fcolor(.XMDesgin.f1)
//                            .listRowSeparator(.hidden, edges: .all)
//                        RankingView(ranking: "No.\(14115)")
//                            .listRowSeparator(.hidden, edges: .top)
//                        // 同城排名部分
//                        XMDesgin.XMMainBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.main, iconName: "", text: "帮Ta冲榜", enable: true) {}
//                        Text("与送礼物一样，会增加解锁Ta的微信的进度。")
//                            .font(.XMFont.f1)
//                    }
//                    .padding(.all)
                }
            }
            .transition(.move(edge: .bottom).combined(with: .opacity).animation(.spring))
        }
        .scrollIndicators(.hidden)
        .refreshable {
            await vm.getData()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
                    .onTapGesture {
                        Apphelper.shared.pushActionSheet(title: "操作", message: "", actions: actions)
                    }
            }
        })
        .ignoresSafeArea()
    }
    
    var postList: some View {
        XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { post in
            PostView(post)
        } loadingView: {
            PostListLoadingView()
        } emptyView: {
            VStack(spacing: 24) {
                Text("他很忙，什么也没留下～")
                    .font(.XMFont.f1)
                    .fcolor(.XMColor.f2)
                LoadingPostView()
            }
            .padding(.top, 12)
        } loadMore: {
            await vm.loadMore()
        } getListData: {
            await vm.getData()
        }
        .padding(.all, 16)
    }
    
    var actions: [UIAlertAction] {
        var result: [UIAlertAction] = [
        ]
        if userId == UserManager.shared.user.userId {
            result.insert(UIAlertAction(title: "编辑个人资料", style: .default, handler: { _ in
                MainViewModel.shared.pushTo(MainViewModel.PagePath.profileEditView)
            }), at: 0)
            return result
        } else {
            result = [UIAlertAction(title: "举报用户", style: .default, handler: { _ in
                Task {
                    await Apphelper.shared.report(type: .user, reportValue: vm.user.userId)
                }
            }),
            UIAlertAction(title: "拉黑用户 / 不再看他", style: .destructive, handler: { _ in
                /*
                 拉黑用户
                 */
                Apphelper.shared.blackUser(userid: self.vm.user.userId)
            })]
            return result
        }
    }
    
    // 顶部图像视图
    var topImageView: some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            let targetHeight = UIScreen.main.bounds.width + offset
            let scale = targetHeight / UIScreen.main.bounds.width
            let blurRadius = offset < 0 ? abs(offset) / UIScreen.main.bounds.width * 66 : 0

            ZStack(alignment: .center) {
                WebImage(str: vm.user.avatar)
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                    .clipped()
                    .ignoresSafeArea()
                Image("profileblur")
                    .resizable()
                    .scaledToFit()
            }
            .scaleEffect(scale, anchor: .top)
            .offset(y: -offset)
            .blur(radius: blurRadius)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    // 个人信息视图
    var profileInfoView: some View {
        VStack {
            Spacer().frame(height: UIScreen.main.bounds.width - 60)
            VStack(alignment: .leading, spacing: 22) {
                // 昵称、标签等信息视图
                userInfoView
                // 按钮视图
                buttonView
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // 昵称、标签等信息视图
    var userInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(vm.user.nickname)
                    .font(.XMFont.big1.bold())
                Spacer()
//                XMDesgin.XMIcon(iconName: "feed_heart", size: 32, color: .XMColor.f1, withBackCricle: true)
                XMDesgin.LikeMeBtn(iconName:vm.user.isUserLike == 0 ? "feed_heart":"feed_heart_fill", size: 32, color: .XMColor.f1, withBackCricle: true) {
                    await vm.tapLikeMe()
                }
                
                
            }
            
            HStack(spacing: 0) {
                Text("\(userInfo.zodiac) · ")
                Text(" \(userInfo.bdsmAttr.bdsmAttrString) · ")
                    .ifshow(show: userInfo.bdsmAttr != 0)
                Text("\(userInfo.emotionalNeeds.emotionalNeedsString) · ")
                    .ifshow(show: userInfo.emotionalNeeds != 0)
                Text("\(userInfo.fansNum)粉丝 · ")
                    .onTapGesture {
                        guard userId == UserManager.shared.user.id else { return }
                        Apphelper.shared.pushNotification(type: .info(message: "暂不可查看。"))
                        MainViewModel.shared.pushTo(MainViewModel.PagePath.myfriends)
                    }
                Text("\(userInfo.followsNum)关注")
                    .onTapGesture {
                        guard userId == UserManager.shared.user.id else { return }
                        Apphelper.shared.pushNotification(type: .info(message: "暂不可查看。"))
                        MainViewModel.shared.pushTo(MainViewModel.PagePath.myfriends)
                    }
            }
            .font(.XMFont.f2)
            .fcolor(.XMColor.f2)
            
            Text(vm.user.signature)
                .lineLimit(4)
                .font(.XMFont.f2)
        }
    }
    
    // 按钮视图
    var buttonView: some View {
        HStack {
            if vm.isLocalUser {
                XMDesgin.SmallBtn(fColor: .XMColor.b1, backColor: .XMColor.f1, iconName: "profile_edit", text: "编辑社交资料") {
                    MainViewModel.shared.pushTo(MainViewModel.PagePath.profileEditView)
                }
                
                XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.b1, iconName: "profile_gift", text: "我的礼物") {
                    MainViewModel.shared.pushTo(MainViewModel.PagePath.mygift)
                }
            } else {
                // 关注按钮
                switch userInfo.isFollow {
                case 1:
                    XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.b1, iconName: "", text: "已关注") {
                        await vm.tapFollow()
                    }
                case 0:
                    XMDesgin.SmallBtn(fColor: .black, backColor: .white, iconName: "profile_follow", text: "关注") {
                        await vm.tapFollow()
                    }
                default: EmptyView()
                }
                // 私信
                XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.b1, iconName: "profile_message", text: "私信") {
                    await vm.tapChat()
                }
                
                if userInfo.wechat.isEmpty {
                    XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.b1, iconName: "profile_gift", text: "送TA上榜") {
                        Apphelper.shared.presentPanSheet(PrueGiftView()
                            .environmentObject(vm), style: .shop)
                    }
                } else {
                    XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .green, iconName: "inforequest_wechat", text: userInfo.wechat) {
                        Apphelper.shared.presentPanSheet(WechatGiftView()
                            .environmentObject(vm), style: .shop)
                    }
                }
            }
        }
    }
    
    // 标签视图
    var tagView: some View {
        VStack(alignment: .leading, spacing: 12) {
//            Text("欢迎与我聊")
//                .font(.XMFont.f1)
//                .bold()
            TagCloudView(data: [XMTag(text: "🍉西瓜"), XMTag(text: "⚽️足球"), XMTag(text: "🏂滑板"), XMTag(text: "🎭戏剧"), XMTag(text: "🎵嘻哈")], spacing: 12) { tag in
                Text(tag.text)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Rectangle().fcolor(.XMColor.b1))
                    .clipShape(Capsule())
            }
        }
    }
    
    // 标签栏视图
    var tabBarView: some View {
        HStack {
            ForEach(ProfileViewModel.ProfileBarItem.allCases, id: \.self) { tabitem in
                let selected = tabitem == vm.currentTab
                XMDesgin.XMButton.init {
                    vm.currentTab = tabitem
                } label: {
                    Text(tabitem.info.name)
                        .font(.XMFont.f1)
                        .bold()
                        .opacity(selected ? 1 : 0.6)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 24)
    }
    
    // 媒体网格视图
    var mediaGridView: some View {
        let w = (UIScreen.main.bounds.width - (16 * 2 + 8 * 2)) / 3
        let h = w / 3 * 4
        
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 8) {
                Spacer().frame(width: 8)
                ForEach(vm.photos, id: \.self.id) { photo in
                    let index = vm.photos.firstIndex(where: { $0.id == photo.id })
                    XMDesgin.XMButton {
                        Apphelper.shared.tapToShowImage(tapUrl: photo.picUrl, rect: nil, urls: vm.photos.map { $0.picUrl })
                    } label: {
                        WebImage(str: photo.picUrl)
                            .scaledToFill()
                            .frame(width: w, height: h)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .transition(
                        .asymmetric(
                            insertion:
                            .movingParts.move(edge: .leading)
                                .combined(with: .opacity)
                                .animation(
                                    .bouncy(duration: 0.5, extraBounce: 0.2)
                                        .delay(Double(index ?? 0) * 0.1)),
                            removal:
                            .movingParts.poof.animation(.easeInOut(duration: 0.5))))
                }
            }
            
            .padding(.vertical, 12)
        }
        .overlay {
            BlurEffectView(style: .systemChromeMaterialDark)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .blur(radius: 14)
                .padding(.leading, 16)
                .overlay {
                    VStack(alignment: .center,
                           spacing: 6) {
                        XMDesgin.XMIcon(iconName: "profile_fire")
                        Text("查看私密照片")
                            .font(.XMFont.f2)
                    }
                }
                .ifshow(show: !vm.photos.isEmpty)
        }
    }
}

#Preview {
    NavigationView(content: {
        NavigationLink(_isActive: .constant(true), destination: {
            ProfileView(userId: "1764504995815882752")
        }, label: {
            Text("hello")
        })
    })
}
