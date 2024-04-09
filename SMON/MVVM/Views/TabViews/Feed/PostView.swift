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

    @Published var hidden: Bool = false

    @MainActor
    func delete() async {
        let t = PostAPI.delete(postId: self.post.id, userId: self.post.userId)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            self.hidden = true
        }
    }
}

struct PostView: View {
    @StateObject var vm: PostViewModel
    init(_ post: XMPost) {
        self._vm = StateObject(wrappedValue: .init(post: post))
    }

    var body: some View {
        if vm.hidden {
            EmptyView()
                .frame(width: 0, height: 0, alignment: .center)
        } else {
            HStack(alignment: .top, spacing: 12) {
                avatarAndLine
                right
            }
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.postdetail(postId: vm.post.id))
            }
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
            .font(.XMFont.f2)
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
            XMLikeBtn(target: PostsOperationAPI.tapLike(postId: vm.post.id), isLiked: vm.post.isLiked.bool, likeNumbers: vm.post.likeNums, contentId: vm.post.id)

            XMDesgin.XMButton {
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.postdetail(postId: vm.post.id))
            } label: {
                XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
            }

            Spacer()

            XMDesgin.XMButton {
                Apphelper.shared.pushActionSheet(title: "操作", message: nil, actions: actions)
            } label: {
                XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
            }
        })
    }

    var actions: [UIAlertAction] {
        var result: [UIAlertAction] = [
        ]
        if self.vm.post.userId == UserManager.shared.user.userId {
            result.insert(UIAlertAction(title: "删除", style: .destructive, handler: { _ in
                Task {
                    await vm.delete()
                }
            }), at: 0)
            return result
        } else {
            result = [UIAlertAction(title: "举报内容", style: .default, handler: { _ in

            }),
            UIAlertAction(title: "拉黑用户 / 不再看他", style: .destructive, handler: { _ in

            })]
            return result
        }
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
                            .frame(width: 148, height: 148 / 3 * 4)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.vertical, 4)
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
            XMDesgin.XMButton {
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profile(userId: vm.post.userId))
            } label: {
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
            .lineSpacing(3)
            .fcolor(.XMDesgin.f1)
            .font(.XMFont.f2)
    }

//
    var avatarAndLine: some View {
        VStack {
            XMDesgin.XMButton {
                MainViewModel.shared.pathPages.append(MainViewModel.PagePath.profile(userId: vm.post.userId))
            } label: {
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

struct LoadingPostView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            avatarAndLine
            right
        }
    }

    var right: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 用户名
            username
            // 文字内容
            text

            // 图片流
            images

            // 底部功能按钮
            toolbtns
            // 评论数
            commentNum
        }
    }

//
    var commentNum: some View {
        Text("评论")
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
            XMLikeBtn(target: PostsOperationAPI.tapLike(postId: "vm.post.id"), isLiked: false, likeNumbers: 0, contentId: "vm.post.id")
              

            XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
              

            Spacer()

            XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
              
        })
    }

//
    var images: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                Spacer().frame(width: 16 + 38 + 12 - 4)

                ForEach(["1", "2", "3"], id: \.self) { url in
                    WebImage(str: url)
                        .scaledToFill()
                        .frame(width: 148, height: 148 / 3 * 4)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                      
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
            Text(String.random(ofLength: Int.random(in: 4...12)))
                .redacted(reason: .placeholder)
                .font(.XMFont.f1b)
                .lineLimit(1)
                .fcolor(.XMDesgin.f1)
              

            Spacer()
            Text(String.random(ofLength: Int.random(in: 4...12)))
                .redacted(reason: .placeholder)
                .font(.XMFont.f3)
                .fcolor(.XMDesgin.f2)
            
        }
    }

//
    var text: some View {
        Text(String.random(ofLength: Int.random(in: 32...120)))
            .redacted(reason: .placeholder)
            .lineSpacing(3)
            .fcolor(.XMDesgin.f1)
            .font(.XMFont.f2)
    }

//
    var avatarAndLine: some View {
        VStack {
            WebImage(str: " vm.post.avatar")
                .scaledToFit()
                .frame(width: 38, height: 38) // Adjust the size as needed
                .clipShape(Circle())
              

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
    LoadingPostView()
//    MainView(vm: .init(currentTabbar: .feed))
}
