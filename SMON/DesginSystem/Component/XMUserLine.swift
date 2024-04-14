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
            switch user.followStatus {
            case 0:
                user.followStatus = 1
            // 我关注他
            case 1:
                user.followStatus = 0
            // 他关注我,没有关系
            case 2:
                user.followStatus = 10
            // 互相关注
            case 10:
                user.followStatus = 2
            default:
                break
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
                        Text("\(user.zodiac) · \(user.emotionalNeeds.emotionalNeedsString)")
                            .font(.XMFont.f2)
                            .fcolor(.XMDesgin.f2)
                    })
                    Spacer()

                    Group {
                        switch user.followStatus {
                        // 我关注他
                        case 1:
                            XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "正在关注") {
                                await tapFollow()
                            }
                        // 他关注我,没有关系
                        case 2, 0:
                            XMDesgin.SmallBtn(fColor: .XMDesgin.b1, backColor: .XMDesgin.f1, iconName: "", text: "关注") {
                                await tapFollow()
                            }
                       
                        // 互相关注
                        case 10:
                            XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "互相关注") {
                                await tapFollow()
                            }
                        default:
                            EmptyView()
                        }
                    }     .changeEffect(.spray(origin: .top) {
                        Group {
                            Image(systemName: "heart.fill")
                            Image(systemName: "sparkles")
                        }
                        .font(.title)
                        .foregroundStyle(Color.XMDesgin.main.gradient)
                    }, value: user.followStatus)
                    
                }
                Text(user.signature)
                    .font(.XMFont.f2)

            })
        }
        .onTapGesture {
            MainViewModel.shared.pushTo(MainViewModel.PagePath.profile(userId: user.userId))
        }
    }
}

#Preview {
    XMUserLine(user: .init())
}
