//
//  XMUserLine.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/9.
//

import SwiftUI

struct XMUserLine: View {
    var user: XMUserProfile
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            XMUserAvatar(str: user.avatar, userId: user.userId, size: 44)

            VStack(alignment: .leading, spacing: 12, content: {
                HStack {
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text(user.nickname)
                            .font(.XMFont.f1b)
                        Text("\(user.zodiac) · \(user.emotionalNeeds)")
                            .font(.XMFont.f2)
                            .fcolor(.XMDesgin.f2)
                    })
                    Spacer()
                    XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "正在关注") {}
                        .ifshow(show: user.isFollow.bool)
                }
                Text(user.signature)
                    .font(.XMFont.f2)

            })
        }
        .onTapGesture {
            MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profile(userId: user.userId))
        }
    }
}

#Preview {
    XMUserLine.init(user: .init())
}
