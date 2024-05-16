//
//  ChatView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/26.
//

import SwiftUI
import TUIChat

struct ChatView: View {
    let userId: String
    let conversation: TUIChatConversationModel

    init(userId: String) {
        self.userId = userId
        self.conversation = TUIChatConversationModel()
        self.conversation.userID = userId
        V2TIMManager.sharedInstance().checkFriend([userId], check: .FRIEND_TYPE_BOTH) { results in
            print(results?.first)
            print(results?.first)
        } fail: { _, _ in
                
        }


    }

    var XMUserId: String {
        var realId = self.userId
        realId.removeFirst()
        return realId
    }

    @State private var info: V2TIMUserFullInfo = .init()

    @MainActor
    func uploadUserInfo() {
        // 设置个人资料
        V2TIMManager.sharedInstance().getUsersInfo([self.conversation.userID]) { infos in
            self.info = infos?.first ?? .init()
        } fail: { _, _ in
        }
    }

    var body: some View {
        ChatViewContainer(conversation: conversation)
            .edgesIgnoringSafeArea(.bottom)
            .ignoresSafeArea(.keyboard)
//            .navigationTitle(self.info.nickName ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    XMDesgin.XMButton {
                        Apphelper.shared.pushActionSheet(title: "操作", message: nil, actions: actions)
                    } label: {
                        XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
                    }
                }
                ToolbarItem(placement: .principal) {
                    XMDesgin.XMButton {
                        MainViewModel.shared.pushTo(MainViewModel.PagePath.profile(userId: XMUserId))
                    } label: {
                        if let avatar = self.info.faceURL{
                            HStack {
                                XMUserAvatar(str: avatar, userId: XMUserId,size: 32)
                                Text(self.info.nickName).font(.XMFont.f2b)
                            }
                        }
                       
                    }
                }
            }
            .task {
                uploadUserInfo()
            }
    }

    var actions: [UIAlertAction] {
        var result: [UIAlertAction] = [
        ]
        result = [
            UIAlertAction(title: "查看用户主页", style: .default, handler: { _ in
                MainViewModel.shared.pushTo(MainViewModel.PagePath.profile(userId: XMUserId))
            }),
            UIAlertAction(title: "举报用户", style: .default, handler: { _ in
                Task {
                    await Apphelper.shared.report(type: .user, reportValue: XMUserId)
                }
            }),
            UIAlertAction(title: "拉黑用户 / 不再看他", style: .destructive, handler: { _ in
                /*
                 拉黑用户
                 */
                Apphelper.shared.blackUser(userid: self.XMUserId)
            }),
        ]
        return result
    }
}

#Preview {
    NavigationView(content: {
//        ChatView(conversation: BIMConversation())
    })
}
