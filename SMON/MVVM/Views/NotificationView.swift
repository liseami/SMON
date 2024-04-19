//
//  NotificationView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

struct XMNotification: Convertible, Identifiable {
    var id: String = "" // ": 1780522214303596544,
    var userId: String = "" // ": 1764610746026688512,
    var avatar: String = "" // ": "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/avatar/default.jpg",
    var nickname: String = "" // ": "zhanglu1385",
    var title: String = "" // ": "每日大赛：zhanglu1385",
    var subTitle: String = "" // ": "点赞了你的大赛帖子",
    var createdAtStr: String = "" // ": "周三 17:02"
    var extraJson: DSF = .init()
}

struct DSF: Convertible {
    var addFlames: String = "" // ": 30,
    var postContent: String = "" // ": "2012年，波多野结衣出席第九届上海国际成人展开幕和第二届台湾成人博览会",
    var postId: String = "" // ": 2,
    var themeId: String = "" // ": 1
}

class NotificationViewModel: XMListViewModel<XMNotification> {
    init() {
        super.init(target: NoticeAPI.dynamicList(page: 1))
        Task { await self.getListData() }
    }
}

struct NotificationView: View {
    @StateObject var vm: NotificationViewModel = .init()
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                XMStateView(vm.list, reqStatus: vm.reqStatus, loadmoreStatus: vm.loadingMoreStatus, pagesize: 30) { notice in
                    noticeLine(notice: notice)
                } loadingView: {
                    ProgressView()
                } emptyView: {
                    XMEmptyView()
                } loadMore: {
                    await vm.loadMore()
                } getListData: {
                    await vm.getListData()
                }
            }
            .padding(.all)
        }
        .navigationTitle("通知")
        .refreshable {
            await vm.getListData()
        }
    }

    func noticeLine(notice: XMNotification) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                XMUserAvatar(str: notice.avatar, userId: notice.userId, size: 32)
                Text(notice.nickname)
                    .font(.XMFont.f1b)

                Text(notice.subTitle)
                    .font(.XMFont.f1)

                Spacer()
                Text(notice.createdAtStr)
                    .font(.XMFont.f3)
                    .fcolor(.XMDesgin.f2)
            }

            if !notice.extraJson.postContent.isEmpty {
                Text(notice.extraJson.postContent)
                    .font(.XMFont.f3)
                    .fcolor(.XMDesgin.f2)
                    .lineLimit(2)
            }

            if !notice.extraJson.addFlames.isEmpty {
                XMDesgin.XMTag(text: "🔥火苗 + \(notice.extraJson.addFlames)")
            }
        }
        .padding(.bottom, 12)
        .overlay(alignment: .bottom) {
            Divider()
        }
        .contentShape(RoundedRectangle(cornerRadius: 1))
        .onTapGesture {
            if notice.extraJson.postId.isEmpty == false {
                MainViewModel.shared.pushTo(MainViewModel.PagePath.postdetail(postId: notice.extraJson.postId))
            }
        }
    }
}

#Preview {
    NotificationView()
}
