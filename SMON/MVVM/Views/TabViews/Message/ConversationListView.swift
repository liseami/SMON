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

    func getConversationList() {
        V2TIMManager.sharedInstance().getConversationList(UInt64(0), count: 300) { conversations, _, _ in
            self.conversations = conversations ?? []
        } fail: { _, _ in
        }
    }
}

struct ConversationListView: View {
    @StateObject var vm: MessageViewModel = .shared

    var body: some View {
        ZStack(alignment: .top, content: {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                    Spacer().frame(height: 12)
                    ForEach(vm.conversations, id: \.self) { conversation in
                        userLine(conversation)
                    }
                })
                .padding(.all, 16)
            }
            .ignoresSafeArea(.container, edges: .bottom)

            XMTopBlurView()
        })

//        ConversationListContainer()
//            .navigationTitle("消息")
//            .navigationBarTitleDisplayMode(.inline)
//            .ignoresSafeArea()
    }

    func userLine(_ conversation : V2TIMConversation) -> some View {
        HStack(alignment: .top, spacing: 12) {
            WebImage(str: conversation.faceUrl)
                .scaledToFill()
                .frame(width: 56, height: 56, alignment: .center)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 6, content: {
                Text(conversation.showName)
                    .font(.XMFont.f1b)
                Text(conversation.lastMessage.description)
                    .font(.XMFont.f2)
                    .lineLimit(2)
                    .fcolor(.XMDesgin.f2)
            })
            Spacer()
            Text(Date.init(unixTimestamp: Double(conversation.c2cReadTimestamp)).string())
                .font(.XMFont.f2)
                .fcolor(.XMDesgin.f2)
        }
        .onTapGesture {
            MainViewModel.shared.pathPages.append(.profile(userId: ""))
        }
    }
}

#Preview {
    MainView(vm: .init(currentTabbar: .message))
}
