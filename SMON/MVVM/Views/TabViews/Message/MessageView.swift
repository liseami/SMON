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
        V2TIMManager.sharedInstance().login("m" + UserManager.shared.user.userId.string, userSig: UserManager.shared.IMInfo.imUserSign) {
            // 登录成功
            print("IM登录成功")
            self.getConversationList()
        } fail: { _, _ in
        }
    }

    @Published var conversations: [V2TIMConversation] = []
    @Published var status: XMRequestStatus = .isLoading

    func getConversationList() {
        V2TIMManager.sharedInstance().getConversationList(UInt64(0), count: 300) { conversations, _, _ in
            self.conversations = conversations ?? []
            self.status = conversations?.isEmpty == true ? .isOKButEmpty : .isOK
        } fail: { _, _ in
            self.status = .isNeedReTry
        }
    }
}

struct MessageView: View {
    @StateObject var vm: MessageViewModel = .shared

    var body: some View {
        ZStack(alignment: .top, content: {
            ScrollView(showsIndicators: false) {
                XMStateView(reqStatus: vm.status) {
                    LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                        Spacer().frame(height: 12)
                        ForEach(vm.conversations, id: \.self) { _ in
                            XMConversationLine(avatar: "", nickname: "", date: .now, lastmessage: "最后一条消息", userid: 2932939)
                        }
                    })
                    .padding(.all, 16)
                } loading: {
                    UserListLoadingView()
                } empty: {
                    XMEmptyView(image: "nomessage_pagepic", text: "暂无消息，去找人聊天吧。")
                }
            }
            .refreshable {
                vm.getConversationList()
            }
            .ignoresSafeArea(.container, edges: .bottom)

            XMTopBlurView()
        })

        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                // 通知按钮
                XMDesgin.XMButton {} label: {
                    XMDesgin.XMIcon(iconName: "home_bell", size: 22)
                }
            }
            // 筛选按钮
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMIcon(iconName: "setting_about", size: 22)
            }
        }

//        ConversationListContainer()
//            .navigationTitle("消息")
//            .navigationBarTitleDisplayMode(.inline)
//            .ignoresSafeArea()
    }
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
                    Circle().fill(Color.XMDesgin.b1.gradient)
                        .frame(width: 56, height: 56, alignment: .center)
                    HStack {
                        VStack(alignment: .leading, spacing: 6, content: {
                            Text(String.random(ofLength: Int.random(in: 4 ... 12)))
                                .font(.XMFont.f1b)
                            Text(String.random(ofLength: Int.random(in: 12 ... 40)))
                                .font(.XMFont.f2)
                                .lineLimit(2)
                                .fcolor(.XMDesgin.f2)
                        })
                        Spacer()
                        Text(String.random(ofLength: 4))
                            .font(.XMFont.f2)
                            .fcolor(.XMDesgin.f2)
                    }
                }
                .redacted(reason: .placeholder)
                .conditionalEffect(.repeat(.shine, every: 1), condition: true)
            }
        })
        .padding(.all, 16)
    }
}
