//
//  UnlockedMeView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct UnlockedInfo: Convertible, Identifiable {
    var id: String = "" // ": 2,
    var userId: String = "" // ": 1764504995815882752,
    var nickname: String = "" // ": "开手机",
    var avatar: String = "" // ":"https://dailycontest.oss-cn-shan7AggIv5rZ9XL.jpg",
    var randomCode: String = "" // ": "11122",
    var updatedAtStr: String = "" // ": "昨天 18:45"
}

class UnlockedMeViewMoedl: XMListViewModel<UnlockedInfo> {
    init() {
        super.init(target: UserRelationAPI.unlock(page: 1))
        Task { await self.getListData() }
    }
}

struct UnlockedMeView: View {
    @StateObject var vm: UnlockedMeViewMoedl = .init()
    var body: some View {
        let a = """
        {
                     "id": 1,
                            "userId": 1764504995815882752,
                            "nickname": "开手机",
                            "avatar": "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/test/XM_iOS_UserPic_202403071914_7AggIv5rZ9XL.jpg",
                            "randomCode": "111dd",
                            "updatedAtStr": "昨天 18:45"
            }
        """.kj.model(UnlockedInfo.self)!
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12, pinnedViews: [], content: {
                XMStateView(vm.list, reqStatus: .isOK, loadmoreStatus: vm.loadingMoreStatus, pagesize: 20) { user in
                    HStack {
                        XMUserAvatar(str: user.avatar, userId: user.id)
                        VStack(alignment: .leading, spacing: 4, content: {
                            Text(user.nickname)
                                .font(.XMFont.f1b)
                            Text(user.updatedAtStr)
                                .font(.XMFont.f3)
                        })
                        Spacer()

                        XMDesgin.XMButton {
                            UIPasteboard.general.setValue(user.randomCode, forPasteboardType: UTType.plainText.identifier)
                            Apphelper.shared.pushNotification(type: .success(message: "已复制"))
                        } label: {
                            XMDesgin.XMTag(text: "口令码：" + user.randomCode)
                                .font(.XMFont.big3.bold())
                        }
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
    UnlockedMeView()
}
