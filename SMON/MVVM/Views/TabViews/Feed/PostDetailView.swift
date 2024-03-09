//
//  PostDetailView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

struct PostDetailView: View {
    @FocusState var input
    @State private var commentInput = "About me"

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24, content: {
                postView
                Capsule()
                    .frame(height: 2)
                    .fcolor(.XMDesgin.b1)
                    .padding(.horizontal)
                commentList
            })
            .padding(.horizontal, 16)
        }
        .scrollDismissesKeyboard(.immediately)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
            }
        })
        .navigationTitle("详情")
        .overlay(alignment: .bottom) {
            inputBar
        }
    }

    var inputBar: some View {
        VStack(alignment: .center, spacing: 0, content: {
            HStack(alignment: .top) {
                XMUserAvatar(str: AppConfig.mokImage!.absoluteString, userId: "32",size: 32)
                    .padding(.top, 6)
                TextField(text: $commentInput, axis: .vertical) {}
                    .lineLimit(...(input ? 4 : 1))
                    .tint(.XMDesgin.main)
                    .font(.XMFont.f2)
                    .focused($input)
                    .padding(.all, 12)
                    .background(.XMDesgin.b1)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.main, iconName: "", text: "发送") {}
                    .padding(.top, 6)
                    .transition(.movingParts.pop(Color.XMDesgin.main))
                    .ifshow(show: input)
            }
            .padding(.all, 12)
            .background(.black)
            .overlay(alignment: .top) {
                Divider()
            }
        })
    }

    var commentList: some View {
        LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
            ForEach(1...120, id: \.self) { _ in
                comment
            }
        })
    }

    var comment: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: AppConfig.mokImage)
                .scaledToFit()
                .frame(width: 38, height: 38) // Adjust the size as needed
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 8, content: {
                HStack(alignment: .center, spacing: 12, content: {
                    Text(String.randomChineseString(length: Int.random(in: 3...12)))
                        .font(.XMFont.f2b)
                        .lineLimit(1)
                        .fcolor(.XMDesgin.f1)
                    Spacer()
                })

                Text(String.randomChineseString(length: Int.random(in: 15...68)))
                    .font(.XMFont.f2)
                    .fcolor(.XMDesgin.f1)

                HStack(alignment: .center, spacing: 12, content: {
                    Text("14小时前")
                        .font(.XMFont.f3)
                        .fcolor(.XMDesgin.f2)
                    Spacer()
                    HStack {
                        XMDesgin.XMIcon(iconName: "feed_heart", size: 16, withBackCricle: true)
                        Text("14929")
                            .font(.XMFont.f3)
                            .bold()
                    }
                    XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
                })

                Text("展开30条回复")
                    .font(.XMFont.f2).bold()
                    .fcolor(.XMDesgin.f2)
            })
        }
    }

    var postView: some View {
        VStack(alignment: .leading, spacing: 24) {
            // 用户信息
            userinfo
            // 文字
            VStack(alignment: .leading, spacing: 12) {
                text
                // 图片
                images
            }
            // 操作按钮
            toolbtns
        }
    }

    var toolbtns: some View {
        HStack(alignment: .center, spacing: 12, content: {
            HStack {
                Text("14929")
                    .font(.XMFont.f3)
                    .bold()
                XMDesgin.XMIcon(iconName: "feed_heart", size: 16, withBackCricle: true)
            }

            HStack {
                Text("2424")
                    .font(.XMFont.f3)
                    .bold()
                XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
            }

            Spacer()

        })
    }

    var text: some View {
        Text(String.randomChineseString(length: Int.random(in: 12...144)))
            .fcolor(.XMDesgin.f1)
            .font(.XMFont.f1)
    }

    var userinfo: some View {
        HStack {
            AsyncImage(url: AppConfig.mokImage)
                .scaledToFit()
                .frame(width: 56, height: 56) // Adjust the size as needed
                .clipShape(Circle())

            Text(String.randomChineseString(length: Int.random(in: 3...12)))
                .font(.XMFont.f1b)
                .lineLimit(1)
                .fcolor(.XMDesgin.f1)
            Spacer()
            Text("14小时前")
                .font(.XMFont.f3)
                .fcolor(.XMDesgin.f2)
        }
    }

    var images: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                Spacer().frame(width: 16 + 38 + 12 - 4)
                let urls = [0, 0, 0, 0].map { _ in
                    AppConfig.mokImage!
                }
                ForEach(urls, id: \.absoluteString) { url in

                    XMDesgin.XMButton {
                        await Apphelper.shared.tapToShowImage(tapUrl: url.absoluteString, rect: nil, urls: urls.map { url in
                            url.absoluteString
                        })
                    } label: {
                        WebImage(str: url.absoluteString)
                            .scaledToFill()
                            .frame(width: 200, height: 200 / 3 * 4)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                Spacer().frame(width: 12)
            }
        }
        .frame(height: CGFloat(200 / 3 * 4))
        .padding(.leading, -CGFloat(16 + 38 + 12))
        .padding(.trailing, -CGFloat(16))
    }
}

#Preview {
    PostDetailView()
}
