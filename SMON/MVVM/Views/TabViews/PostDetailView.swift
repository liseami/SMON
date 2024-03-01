//
//  PostDetailView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

struct PostDetailView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24, content: {
                postView
                Capsule()
                    .frame(height: 2)
                    .foregroundColor(Color.XMDesgin.b1)
                    .padding(.horizontal)
                commentList
            })
            .padding(.horizontal, 16)
        }
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
                        .font(.subheadline.bold())
                        .lineLimit(1)
                        .foregroundStyle(Color.XMDesgin.f1)
                    Spacer()
                })

                Text(String.randomChineseString(length: Int.random(in: 15...68)))
                    .font(.subheadline)
                    .foregroundStyle(Color.XMDesgin.f1)

                HStack(alignment: .center, spacing: 12, content: {
                    Text("14小时前")
                        .font(.caption)
                        .foregroundStyle(Color.XMDesgin.f2)
                    Spacer()
                    HStack {
                        XMDesgin.XMIcon(iconName: "feed_heart", size: 16, withBackCricle: true)
                        Text("14929")
                            .font(.caption)
                            .bold()
                    }
                    XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
                })

                Text("展开30条回复")
                    .font(.subheadline).bold()
                    .foregroundStyle(Color.XMDesgin.f2)
            })
        }
    }

    var postView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                AsyncImage(url: AppConfig.mokImage)
                    .scaledToFit()
                    .frame(width: 56, height: 56) // Adjust the size as needed
                    .clipShape(Circle())

                Text(String.randomChineseString(length: Int.random(in: 3...12)))
                    .font(.subheadline.bold())
                    .lineLimit(1)
                    .foregroundStyle(Color.XMDesgin.f1)
                Spacer()
                Text("14小时前")
                    .font(.caption)
                    .foregroundStyle(Color.XMDesgin.f2)
            }

            VStack(alignment: .leading) {
                Text(String.randomChineseString(length: Int.random(in: 12...144)))
                    .foregroundStyle(Color.XMDesgin.f1)
                    .font(.body)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        Spacer().frame(width: 16 + 38 + 12 - 4)
                        ForEach(0...3, id: \.self) { _ in
                            AsyncImage(url: AppConfig.mokImage) { image in
                                image.resizable(true)
                                    .scaledToFill()
                                    .frame(width: 160, height: 160 / 3 * 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                Color.XMDesgin.b1
                                    .frame(width: 160, height: 160 / 3 * 4)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        Spacer().frame(width: 12)
                    }
                }
                .frame(height: 160 / 3 * 4)
                .padding(.leading, -(16 + 38 + 12))
                .padding(.trailing, -16)
                HStack(alignment: .center, spacing: 12, content: {
                    HStack {
                        Text("14929")
                            .font(.caption)
                            .bold()
                        XMDesgin.XMIcon(iconName: "feed_heart", size: 16, withBackCricle: true)
                    }

                    XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)

                    Spacer()
                    XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
                })
                .padding(.top, 6)
            }
        }
        .padding(.top, 12)
    }
}

#Preview {
    PostDetailView()
}
