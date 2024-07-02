//
//  MainView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import Introspect
import SwiftUI
import TUIChat

struct MainView: View {
    @State private var showPP: Bool = false
    @StateObject var vm: MainViewModel = .shared
    var body: some View {
        NavigationStack(path: $vm.pathPages) {
            ZStack {
                // 一级页面
                tabViews
                // Tabbar
                MainTabbar()
                // 启动动画
                LaunchScreenAnimation()
            }
            .task {
                Apphelper.shared.closeKeyBoard()
                // 进入主页面，登录腾讯IM
                await UserManager.shared.getImUserSign()
            }
            .environmentObject(vm)
            .navigationBarTransparent(true)
            .navigationDestination(for: MainViewModel.PagePath.self) { path in
                Group {
                    switch path {
                    case .faceAuth : FaceAuthView()
                    case .mygift : MyGiftView()
                    case .mybill : MyBill()
                    case .myCoinView : MyCoinView()
                    case .notification: NotificationView()
                    case .setting: SettingView()
                    case .myhotinfo: MyHotInfoView()
                    case .myfriends: RelationListView()
                    case .postdetail(let postId): PostDetailView(postId)
                    case .profileEditView: ProfileEditView()
                    case .profile(let userId): ProfileView(userId: userId)
                    case .chat(let userId): ChatView(userId: userId)
                    case .flamedetail: FlameDetailView()
                    case .dsList: XMDSListView()
                    }
                }
                .navigationBarTransparent(false)
                .toolbarRole(.editor)
                
            }
        }
        .overlay {
            ZStack{
                Button {
                    
                } label: {
                    Text("   ")
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .background(.lightGray)
                        .opacity(0.1)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                VStack{
                    Spacer()
                    ZStack{
                        Image("xm_root_ppImage")
                            .resizable()
                            .frame(width: 244, height: 64)
                        
                        XMDesgin.XMButton {
                            showPP = false
                        } label: {
                            XMDesgin.XMIcon(iconName: "xm_root_delImage", size: 14, withBackCricle: false)
                        }
                        .padding(EdgeInsets(top: 8, leading: 222, bottom: 42, trailing: 8))
                        HStack{
                            if vm.receivedData != nil{
                                WebImage(str: vm.receivedData?["avatar"] as! String )
                                    .scaledToFill()
                                    .frame(width: 52, height: 52)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                VStack{
                                    Text("\(vm.receivedData?["nickname"] as! String)")
                                        .frame(width: 170, height: 20, alignment: .leading)
                                        .font(.XMFont.f2)
                                    Text("今日TA与你最匹配,快来聊聊吧")
                                        .frame(width: 170, height: 20, alignment: .leading)
                                        .font(.XMFont.f3)
                                }
                            }else{
                                EmptyView()
                            }
                            
                        }
                    }
                    .padding(.leading, 112 - UIScreen.main.bounds.width/2)
                    .padding(.bottom, 74)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(.clear)
                .onTapGesture {
                    Task{
                        let userID: String = vm.receivedData?["userId"] as! String
                        showPP = false
                        MainViewModel.shared.pushTo(MainViewModel.PagePath.chat(userId: "m" + userID))
                        
                        let t = RecommendRecordAPI.salutation(toUserId: userID)
                        let r = await Networking.request_async(t)
                        if r.is2000Ok {
                        }
                    }
                }
            }
            .ifshow(show: showPP)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.GETPPINFOSUCCESS, object: nil)) { obj in
            if let newReply = obj.object as? [String: Any]{
                showPP = true
                vm.receivedData = newReply
            }
        }
    }

    var tabViews: some View {
        Group {
            switch vm.currentTabbar {
            case .feed:
                // 信息流
                PostFeedView()
            case .rank:
                // 首页
//                HomeView()
                RankView()
            case .message:
                // 消息
                MessageView()
            case .profile:
                // 个人主页
                ProfileHomeView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                // 通知按钮
                XMDesgin.XMButton {
                    MainViewModel.shared.pushTo(MainViewModel.PagePath.notification)
                } label: {
                    XMDesgin.XMIcon(iconName: "home_bell", size: 22)
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(\.colorScheme, .dark)
}
