//
//  NotificationView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

class NotificationViewModel: ObservableObject {}

struct NotificationView: View {
    @StateObject var vm: NotificationViewModel = .init()
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(0 ... 120, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            XMUserAvatar(str: AppConfig.mokImage!.absoluteString, userId: "", size: 32)
                            Text("赵纯想1号")
                                .font(.XMFont.f1b)
                            Text("赞了你的大赛帖子")
                                .font(.XMFont.f1)
                            Spacer()
                        }
                        Text("帖子内容，帖子内容帖子内容帖子内容帖子内容帖子内容")
                            .font(.XMFont.f3)
                            .fcolor(.XMDesgin.f2)
                            .lineLimit(2)
                        XMDesgin.XMTag(text: "🔥火苗 + 100")
                    }
                    .padding(.bottom, 12)
                    .overlay(alignment: .bottom) {
                        Divider()
                    }
                }
            }
            .padding(.all)
        }
        .navigationTitle("通知")
    }
}

#Preview {
    NotificationView()
}
