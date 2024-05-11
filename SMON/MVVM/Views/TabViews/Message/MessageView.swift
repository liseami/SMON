//
//  MessageView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI
import TIMCommon

class MessageViewModel: NSObject, ObservableObject, V2TIMSDKListener {
    static let shared = MessageViewModel()
    override init() {
        super.init()
        V2TIMManager.sharedInstance().add(self)
        V2TIMManager.sharedInstance().login("m" + UserManager.shared.user.userId, userSig: UserManager.shared.IMInfo.imUserSign) {
            // 登录成功
            print("IM登录成功")
            DispatchQueue.main.async {
                self.uploadUserInfo()
                self.getConversationList()
            }
        } fail: { _, _ in
        }
    }

    @Published var conversations: [V2TIMConversation] = []
    @Published var status: XMRequestStatus = .isLoading

    /*
     获取聊天列表
     */
    @MainActor
    func getConversationList() {
        V2TIMManager.sharedInstance().getConversationList(UInt64(0), count: 300) { conversations, _, _ in
            self.conversations = conversations ?? []
            self.status = conversations?.isEmpty == true ? .isOKButEmpty : .isOK
        } fail: { _, _ in
            self.status = .isNeedReTry
        }
    }

    @MainActor
    func uploadUserInfo() {
        // 设置个人资料
        let info = V2TIMUserFullInfo()
        info.nickName = UserManager.shared.user.nickname
        info.faceURL = UserManager.shared.user.avatar
        V2TIMManager.sharedInstance().setSelfInfo(info) {} fail: { _, _ in
        }
    }
    
    
}

extension V2TIMConversation: Identifiable {}

struct MessageView: View {
    @StateObject var vm: MessageViewModel = .shared

    var body: some View {
        ZStack(alignment: .top, content: {
//            converstaionList
            ConversationListContainer()
                .ignoresSafeArea()
            XMTopBlurView()
            
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("消息")
                    .font(.XMFont.f1)
                    .bold()
            }
//            ToolbarItem(placement: .topBarLeading) {
//                // 通知按钮
//                XMDesgin.XMButton {} label: {
//                    XMDesgin.XMIcon(iconName: "home_bell", size: 22)
//                }
//            }
            // 筛选按钮
//            ToolbarItem(placement: .topBarTrailing) {
//                XMDesgin.XMIcon(iconName: "setting_about", size: 22)
//            }
        }
    }

//    var converstaionList: some View {
//        ScrollView(showsIndicators: false) {
//            LazyVStack(alignment: .leading, spacing: 12, pinnedViews: [], content: {
//                XMStateView(vm.conversations, reqStatus: vm.status, loadmoreStatus: .isOK) { conversation in
//                    let xmuserId = String(conversation.userID.suffix(from: conversation.userID.firstIndex(of: "m")!))
//
//                    XMDesgin.XMButton(action: {
//                        MainViewModel.shared.pushTo(MainViewModel.PagePath.chat(userId: xmuserId))
//                    }, label: {
//                        XMConversationLine(avatar: "", nickname: conversation.showName ?? "", date: conversation.lastMessage.timestamp ?? .now, lastmessage: "conversation.lastMessage.textElem ?? ", userid: conversation.userID)
//                    })
//                } loadingView: {
//                    UserListLoadingView()
//                } emptyView: {
//                    XMEmptyView(image: "nomessage_pagepic", text: "暂无消息，去找人聊天吧。")
//                } loadMore: {}
//            })
//            .padding(.horizontal, 16)
//        }
//        .refreshable {
//            vm.getConversationList()
//        }
//        .ignoresSafeArea(.container, edges: .bottom)
//    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .message))
}

struct UserListLoadingView: View {
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
            Spacer().frame(height: 12)
            ForEach(0 ... 99, id: \.self) { _ in
                HStack(alignment: .top, spacing: 12) {
                    Circle().fill(Color.XMColor.b1.gradient)
                        .frame(width: 56, height: 56, alignment: .center)
                    HStack {
                        VStack(alignment: .leading, spacing: 6, content: {
                            Text(String.random(ofLength: Int.random(in: 4 ... 12)))
                                .font(.XMFont.f1b)
                            Text(String.random(ofLength: Int.random(in: 12 ... 40)))
                                .font(.XMFont.f2)
                                .lineLimit(2)
                                .fcolor(.XMColor.f2)
                        })
                        Spacer()
                        Text(String.random(ofLength: 4))
                            .font(.XMFont.f2)
                            .fcolor(.XMColor.f2)
                    }
                }
                .redacted(reason: .placeholder)
                .conditionalEffect(.repeat(.shine, every: 1), condition: true)
            }
        })
        
    }
}
