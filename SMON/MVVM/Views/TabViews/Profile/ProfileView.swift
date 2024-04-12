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
                    mediaGridView
                    XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { post in
                        PostView(post)
                    } loadingView: {
                        PostListLoadingView()
                    } emptyView: {
                        VStack(spacing: 24) {
                            Text("他很忙，什么也没留下～")
                                .font(.XMFont.f1)
                                .fcolor(.XMDesgin.f2)
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
            }
        }
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
    
    var actions: [UIAlertAction] {
        var result: [UIAlertAction] = [
        ]
        if userId == UserManager.shared.user.userId {
            result.insert(UIAlertAction(title: "编辑个人资料", style: .default, handler: { _ in
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profileEditView)
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
        ZStack(alignment: .center, content: {
            WebImage(str: vm.user.avatar)
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .clipped()
                .ignoresSafeArea()
            Image("profileblur")
                .resizable()
                .scaledToFit()
        })
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
            Text(vm.user.nickname)
                .font(.XMFont.big1.bold())
            
            HStack(spacing: 0) {
                Text("\(userInfo.zodiac) · ")
                Text(" \(userInfo.bdsmAttr.bdsmAttrString) · ")
                    .ifshow(show: userInfo.bdsmAttr != 0)
                Text("\(userInfo.emotionalNeeds.emotionalNeedsString) · ")
                    .ifshow(show: userInfo.emotionalNeeds != 0)
                Text("\(userInfo.fansNum)粉丝 · ")
                    .onTapGesture {
                        MainViewModel.shared.pathPages.append(MainViewModel.PagePath.myfriends)
                    }
                Text("\(userInfo.followsNum)关注")
                    .onTapGesture {
                        MainViewModel.shared.pathPages.append(MainViewModel.PagePath.myfriends)
                    }
            }
            .font(.XMFont.f2)
            .fcolor(.XMDesgin.f2)
            
            Text(vm.user.signature)
                .lineLimit(4)
                .font(.XMFont.f2)
        }
    }
    
    // 按钮视图
    var buttonView: some View {
        HStack {
            if vm.isLocalUser {
                XMDesgin.SmallBtn(fColor: .black, backColor: .white, iconName: "profile_edit", text: "编辑社交资料") {
                    MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profileEditView)
                }
            } else {
                // 关注按钮
                switch userInfo.isFollow {
                case 1:
                    XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "已关注") {
                        await vm.tapFollow()
                    }
                case 0:
                    XMDesgin.SmallBtn(fColor: .black, backColor: .white, iconName: "profile_follow", text: "关注") {
                        await vm.tapFollow()
                    }
                default: EmptyView()
                }
                // 私信
                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "profile_message", text: "私信") {
                    await vm.tapChat()
                }
//                // 微信
//                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "inforequest_wechat", text: userInfo.wechat) {
//                    Apphelper.shared.presentPanSheet(WechatGiftView()
//                        .environmentObject(vm), style: .shop)
//                }
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
                    .background(Rectangle().fcolor(.XMDesgin.b1))
                    .clipShape(Capsule())
            }
        }
    }
    
    // 标签栏视图
    var tabBarView: some View {
        HStack {
            ForEach(ProfileViewModel.ProfileBarItem.allCases, id: \.self) { tabitem in
                let selected = tabitem == vm.currentTab
                Text(tabitem.info.name)
                    .font(.XMFont.f1)
                    .bold()
                    .opacity(selected ? 1 : 0.6)
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
                    XMDesgin.XMButton {
                        Apphelper.shared.tapToShowImage(tapUrl: photo.picUrl, rect: nil, urls: vm.photos.map { $0.picUrl })
                    } label: {
                        WebImage(str: photo.picUrl)
                            .scaledToFill()
                            .frame(width: w, height: h)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    NavigationView(content: {
        NavigationLink(_isActive: .constant(true), destination: {
            ProfileView(userId: "0")
        }, label: {
            Text("hello")
        })
    })
}
