//
//  NotificationView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI



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
                    .font(.XMFont.f1)

                Spacer()
                Text(notice.createdAtStr)
                    .font(.XMFont.f3)
                    .fcolor(.XMColor.f2)
            }
            Text(notice.subTitle)
                .font(.XMFont.f1b)

            if !notice.extraJson.postContent.isEmpty {
                Text(notice.extraJson.postContent)
                    .font(.XMFont.f3)
                    .fcolor(.XMColor.f2)
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
