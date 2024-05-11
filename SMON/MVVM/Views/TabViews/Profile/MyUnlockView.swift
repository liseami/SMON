//
//  MyUnlockView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/26.
//

import SwiftUI
import UniformTypeIdentifiers
struct MyUnlockInfo: Convertible, Identifiable {
    var id: String = "" // ": 2,
    var userId: String = "" // ": 1764504995815882752,
    var nickname: String = "" // ": "开手机",
    var avatar: String = "" // ":"https://dailycontest.oss-cn-shan7AggIv5rZ9XL.jpg",
    var randomCode: String = "" // ": "11122",
    var updatedAtStr: String = "" // ": "昨天 18:45"
}

class MyUnlockViewMoedl: XMListViewModel<MyUnlockInfo> {
    init() {
        super.init(target: UserRelationAPI.unlocked(page: 1))
        Task { await self.getListData() }
    }
}

struct RespWechat: Convertible {
    var wechat: String = ""
}

struct MyUnlockView: View {
    @StateObject var vm: UnlockedMeViewMoedl = .init()
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: .isOK, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { user in
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            XMUserAvatar(str: user.avatar, userId: user.userId)
                            VStack(alignment: .leading, spacing: 4, content: {
                                Text(user.nickname)
                                    .font(.XMFont.f1b)
                                Text(user.updatedAtStr)
                                    .font(.XMFont.f3)
                                    .fcolor(.XMColor.f2)
                            })
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 4, content: {
                            HStack {
                                Text("微信号")
                                    .font(.XMFont.f1b.bold())
                                Spacer()

                                XMDesgin.XMButton.init {
                                    let t = UserRelationAPI.wechatCopy(id: user.id)
                                    let r = await Networking.request_async(t)
                                    if let wechat = r.mapObject(RespWechat.self), r.is2000Ok {
                                        print(wechat)
                                        DispatchQueue.main.async {
                                            UIPasteboard.general.setValue(String(wechat.wechat), forPasteboardType: UTType.plainText.identifier)
                                            Apphelper.shared.pushNotification(type: .success(message: "已复制"))
                                        }
                                    }
                                } label: {
                                    XMDesgin.XMTag(text: "复制微信号", bgcolor: Color.green)
                                }
                            }
                            .padding(.all, 12)
                            .background(Color.XMColor.b1)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            HStack {
                                Text("口令码：" + user.randomCode)
                                    .font(.XMFont.f1b.bold())
                                Spacer()

                                XMDesgin.XMButton.init {
                                    DispatchQueue.main.async {
                                        UIPasteboard.general.setValue(user.randomCode, forPasteboardType: UTType.plainText.identifier)
                                    }
                                    Apphelper.shared.pushNotification(type: .success(message: "已复制"))
                                } label: {
                                    XMDesgin.XMTag(text: "复制口令码", bgcolor: Color.XMColor.main)
                                }
                            }
                            .padding(.all, 12)
                            .background(Color.XMColor.b1)
                            .clipShape(Capsule())
                        })
                    }

                } loadingView: {
                    UserListLoadingView()
                } emptyView: {
                    XMEmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }
            })
            .padding(.all)
        }
    }
}

#Preview {
    MyUnlockView()
}
