//
//  ProfileView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI
import SwiftUIX
import Tagly

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel
    var userId: String
    init(userId: String) {
        self._vm = StateObject(wrappedValue: .init(userId: userId))
        self.userId = userId
    }

    var body: some View {
        ScrollView(content: {
            ZStack(alignment: .top) {
                topImage
                profileInfo
            }
            tabBar
            mediaView
            tags
        })
        .ignoresSafeArea()
    }

    var topImage: some View {
        WebImage(str: AppConfig.mokImage!.absoluteString)
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            .clipped()
            .ignoresSafeArea()
    }

    var profileInfo: some View {
        VStack {
            Spacer().frame(height: UIScreen.main.bounds.width - 60)
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("赵纯想")
                        .font(.largeTitle.bold())
                    Text("天蝎座 · Sub · 长期关系 · 3k粉丝 · 293关注")
                        .font(.subheadline).foregroundStyle(.secondary)

                    Text(String.randomChineseString(length: 120))
                        .lineLimit(4)
                        .font(.subheadline)
                })

                btns
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(alignment: .top) {
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]), startPoint: .top, endPoint: .center)
                    .frame(height: 80)
//                            .offset(y:-12)
            }
        }
    }

    var btns: some View {
        HStack {
            if vm.isLocalUser {
                XMDesgin.SmallBtn(fColor: .black, backColor: .white, iconName: "profile_edit", text: "编辑社交资料") {}
            } else {
                XMDesgin.SmallBtn(fColor: .black, backColor: .white, iconName: "profile_follow", text: "关注") {}

                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "profile_message", text: "私信") {}

                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "inforequest_wechat", text: "zhao***lis") {}
            }
        }
    }

    var tags: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("欢迎与我聊")
                .font(.body)
                .bold()
            TagCloudView(data: [XMTag(text: "🍉西瓜"), XMTag(text: "⚽️足球"), XMTag(text: "🏂滑板"), XMTag(text: "🎭戏剧"), XMTag(text: "🎵嘻哈")], spacing: 12, content: { tag in
                Text(tag.text)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Rectangle().foregroundColor(.XMDesgin.b1))
                    .clipShape(Capsule())
            })
        })
    }

    var tabBar: some View {
        HStack {
            ForEach(ProfileViewModel.ProfileBarItem.allCases, id: \.self) { tabitem in
                let selected = tabitem == vm.currentTab
                Text(tabitem.info.name)
                    .font(.body)
                    .bold()
                    .opacity(selected ? 1 : 0.6)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 24)
    }

    var w: CGFloat {
        (UIScreen.main.bounds.width - (16 * 2 + 8)) / 2
    }

    var h: CGFloat {
        w / 3 * 4
    }

    var mediaView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 16) {
            ForEach(0 ... 99, id: \.self) { _ in

                WebImage(str: AppConfig.mokImage!.absoluteString)
                    .scaledToFill()
                    .frame(width: w, height: h)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.all)
    }
}

#Preview {
    ProfileView(userId: "32")
//    MainView(vm: .init(currentTabbar: .profile))
}
