//
//  XMUserLine.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/9.
//

import SwiftUI

struct XMUserLine: View {
    @MainActor
    func tapFollow() async {
        let t = UserRelationAPI.tapFollow(followUserId: user.userId)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            user.isFollow.toggle()
            if user.isEachOther.bool {
                user.isEachOther.toggle()
            }
        }
    }

    @State var user: XMUserProfile
    init(user: XMUserProfile) {
        self._user = State(initialValue: user)
    }

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

                    if user.isEachOther.bool {
                        XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "互相关注") {
                            await tapFollow()
                        }
                    } else {
                        if !user.isFollow.bool {
                            XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "正在关注") {
                                await tapFollow()
                            }
                        } else {
                            XMDesgin.SmallBtn(fColor: .XMDesgin.b1, backColor: .XMDesgin.f1, iconName: "", text: "关注") {
                                await tapFollow()
                            }
                        }
                    }
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
    XMUserLine(user: .init())
}
