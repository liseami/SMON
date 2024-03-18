//
//  PostView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI

class PostViewModel: ObservableObject {
    @Published var post: XMPost
    init(post: XMPost) {
        self.post = post
    }
}

struct PostView: View {
    @StateObject var vm: PostViewModel
    init(_ post: XMPost) {
        self._vm = StateObject(wrappedValue: .init(post: post))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            avatarAndLine
            right
        }
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            MainViewModel.shared.pathPages.append(MainViewModel.PagePath.postdetail(postId: ""))
        }
    }

    var right: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 用户名
            username
            // 文字内容
            text
                .ifshow(show: vm.post.postContent.isEmpty == false)
            // 图片流
            images
                .ifshow(show: vm.post.postAttachs.isEmpty == false)
            // 底部功能按钮
            toolbtns
            // 评论数
            commentNum
        }
    }

//
    var commentNum: some View {
        Text("\(vm.post.commentNums == 0 ? "" : vm.post.commentNums.string)评论")
            .font(.XMFont.f3)
            .bold()
            .padding(.top, 6)
            .background(content: {
                Color.black
            })
            .padding(.leading, -CGFloat(38 + 12))
    }

//
    var toolbtns: some View {
        HStack(alignment: .center, spacing: 12, content: {
            HStack {
                Text("\(vm.post.likeNums ?? 0)")
                    .font(.XMFont.f3)
                    .bold()
                XMDesgin.XMButton {} label: {
                    XMDesgin.XMIcon(iconName: "feed_heart", size: 16, withBackCricle: true)
                }
            }

            XMDesgin.XMButton {
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.postdetail(postId: ""))
            } label: {
                XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
            }

            Spacer()

            XMDesgin.XMButton {
                Apphelper.shared.pushActionSheet(title: "操作", message: nil, actions: [
                    UIAlertAction(title: "举报内容", style: .default, handler: { _ in

                    }),
                    UIAlertAction(title: "拉黑用户 / 不再看他", style: .destructive, handler: { _ in

                    })
                ])
            } label: {
                XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
            }
        })
    }

//
    var images: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                Spacer().frame(width: 16 + 38 + 12 - 4)
                let urls = vm.post.postAttachs.map { $0.picUrl }
                ForEach(urls, id: \.self) { url in
                    XMDesgin.XMButton {
                        Apphelper.shared.tapToShowImage(tapUrl: url, rect: nil, urls: urls)
                    } label: {
                        WebImage(str: url)
                            .scaledToFill()
                            .frame(width: 160, height: 160 / 3 * 4)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                Spacer().frame(width: 12)
            }
        }
        .frame(height: CGFloat(160 / 3 * 4))
        .padding(.leading, -CGFloat(16 + 38 + 12))
        .padding(.trailing, -CGFloat(16))
    }

//
    var username: some View {
        HStack {
            XMDesgin.XMButton {} label: {
                Text(vm.post.nickname)
                    .font(.XMFont.f1b)
                    .lineLimit(1)
                    .fcolor(.XMDesgin.f1)
            }

            Spacer()
            Text(vm.post.createdAtStr)
                .font(.XMFont.f3)
                .fcolor(.XMDesgin.f2)
        }
    }

//
    var text: some View {
        Text(vm.post.postContent)
            .fcolor(.XMDesgin.f1)
            .font(.XMFont.f2)
    }

//
    var avatarAndLine: some View {
        VStack {
            XMDesgin.XMButton {} label: {
                WebImage(str: vm.post.avatar)
                    .scaledToFit()
                    .frame(width: 38, height: 38) // Adjust the size as needed
                    .clipShape(Circle())
            }

            RoundedRectangle(cornerRadius: 99)
                .frame(width: 2)
                .frame(maxHeight: .infinity)
                .fcolor(.XMDesgin.f2)
        }
    }
}

#Preview {
//    PostView()
//        .environmentObject(MainViewModel())
    MainView(vm: .init(currentTabbar: .feed))
}
