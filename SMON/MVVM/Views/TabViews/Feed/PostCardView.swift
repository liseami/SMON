//
//  PostCardView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/5/31.
//

import SwiftUI

struct PostCardView: View {
    @StateObject var vm: PostViewModel
    init(_ post: XMPost) {
        self._vm = StateObject(wrappedValue: .init(post: post))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            WebImage(str: vm.post.postAttachs.first?.picUrl ?? "")
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .ifshow(show: vm.post.postAttachs.first?.picUrl.isEmpty == false)
            VStack(alignment: .leading, spacing: 8) {
                Text(vm.post.postContent)
                    .lineLimit(2)
                    .font(.XMFont.f2b)
                    .fcolor(.XMColor.f1)
                    .ifshow(show: vm.post.postContent.isEmpty == false)
                HStack {
                    XMUserAvatar(str: vm.post.avatar, userId: vm.post.userId, size: 24)
                    Text(vm.post.nickname)
                        .lineLimit(1)
                        .font(.XMFont.f3)
                        .fcolor(.XMColor.f2)
                    Spacer()
                    XMLikeBtn(target: PostsOperationAPI.tapLike(postId: vm.post.id),isInCard: true, isLiked: vm.post.isLiked.bool, likeNumbers: vm.post.likeNums, contentId: vm.post.id)
                }
            }
            .padding(.all, 8)
        })
        .background(Color.XMColor.b1)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            MainViewModel.shared.pushTo(MainViewModel.PagePath.postdetail(postId: vm.post.id))
        }
//        if vm.hidden {
//            EmptyView()
//                .frame(width: 0, height: 0, alignment: .center)
//        } else {
//            HStack(alignment: .top, spacing: 12) {
//                avatarAndLine
//                right
//            }
//            .contentShape(RoundedRectangle(cornerRadius: 12))
//            .onTapGesture {
//                MainViewModel.shared.pushTo(MainViewModel.PagePath.postdetail(postId: vm.post.id))
//            }
//        }
    }
//
//    var right: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // 用户名
//            username
//            // 文字内容
//            text
//                .ifshow(show: vm.post.postContent.isEmpty == false)
//            // 图片流
//            images
//                .ifshow(show: vm.post.postAttachs.isEmpty == false)
//            // 底部功能按钮
//            toolbtns
//            // 评论数
//            commentNum
//        }
//    }
//
    ////
//    var commentNum: some View {
//        Text("\(vm.post.commentNums == 0 ? "" : vm.post.commentNums.string)评论")
//            .font(.XMFont.f3)
//            .fcolor(.XMColor.f2)
//            .padding(.top, 6)
//            .background(content: {
//                Color.black
//            })
//            .padding(.leading, -CGFloat(38 + 12))
//    }
//
    ////
//    var toolbtns: some View {
//        HStack(alignment: .center, spacing: 12, content: {
//            XMLikeBtn(target: PostsOperationAPI.tapLike(postId: vm.post.id), isLiked: vm.post.isLiked.bool, likeNumbers: vm.post.likeNums, contentId: vm.post.id)
//
//            XMDesgin.XMButton {
//                MainViewModel.shared.pushTo(MainViewModel.PagePath.postdetail(postId: vm.post.id))
//            } label: {
//                XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
//            }
//
//            Spacer()
//
//            XMDesgin.XMButton {
//                Apphelper.shared.pushActionSheet(title: "操作", message: nil, actions: actions)
//            } label: {
//                XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
//            }
//        })
//    }
//
//    var actions: [UIAlertAction] {
//        var result: [UIAlertAction] = [
//        ]
//        if self.vm.post.userId == UserManager.shared.user.userId {
//            result.insert(UIAlertAction(title: "删除", style: .destructive, handler: { _ in
//                Task {
//                    await vm.delete()
//                }
//            }), at: 0)
//            return result
//        } else {
//            result = [UIAlertAction(title: "举报内容", style: .default, handler: { _ in
//                Task {
//                    await Apphelper.shared.report(type: .post, reportValue: vm.post.id)
//                    DispatchQueue.main.async {
//                        self.vm.hidden = true
//                    }
//                }
//            }),
//            UIAlertAction(title: "拉黑用户 / 不再看他", style: .destructive, handler: { _ in
//                /*
//                 拉黑用户
//                 */
//                Apphelper.shared.blackUser(userid: self.vm.post.userId)
//                DispatchQueue.main.async {
//                    self.vm.hidden = true
//                }
//            })]
//            return result
//        }
//    }
//
    ////
//    var images: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 4) {
//                Spacer().frame(width: 16 + 38 + 12 - 4)
//                let urls = vm.post.postAttachs.map { $0.picUrl }
//                ForEach(urls, id: \.self) { url in
//                    XMDesgin.XMButton {
//                        Apphelper.shared.tapToShowImage(tapUrl: url, rect: nil, urls: urls)
//                    } label: {
//                        WebImage(str: url)
//                            .scaledToFill()
//                            .frame(width: 148, height: 148 / 3 * 4)
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                            .padding(.vertical, 4)
//                    }
//                }
//                Spacer().frame(width: 12)
//            }
//        }
//        .frame(height: CGFloat(160 / 3 * 4))
//        .padding(.leading, -CGFloat(16 + 38 + 12))
//        .padding(.trailing, -CGFloat(16))
//    }
//
    ////
//    var username: some View {
//        HStack {
//            XMDesgin.XMButton {
//                MainViewModel.shared.pushTo(MainViewModel.PagePath.profile(userId: vm.post.userId))
//            } label: {
//                Text(vm.post.nickname)
//                    .font(.XMFont.f2b)
//                    .fcolor(.XMColor.f1)
//                    .lineLimit(1)
//            }
//
//            Spacer()
//            Text(vm.post.createdAtStr)
//                .font(.XMFont.f2)
//                .fcolor(.XMColor.f2)
//        }
//    }
//
    ////
//    var text: some View {
//        Text(vm.post.postContent)
//            .lineSpacing(3)
//            .fcolor(.XMColor.f1)
//            .font(.XMFont.f2)
//    }
//
    ////
//    var avatarAndLine: some View {
//        VStack {
//            XMUserAvatar(str: vm.post.avatar, userId: vm.post.userId, size: 38)
//            RoundedRectangle(cornerRadius: 99)
//                .frame(width: 2)
//                .frame(maxHeight: .infinity)
//                .fcolor(.XMColor.f2)
//        }
//    }
}

#Preview {
    PostCardView(.init())
        .frame(maxWidth: (UIScreen.main.bounds.width - 32 - 4) / 2)
}
