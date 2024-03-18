//
//  PostDetailView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

class PostDetailViewModel: XMModRequestViewModel<XMPostDetail> {
    let postId: Int
    init(postId: Int) {
        self.postId = postId
        super.init(pageName: "") {
            PostAPI.detail(postId: postId, userId: UserManager.shared.user.userId)
        }
    }
}

struct PostDetailView: View {
    @FocusState var input
    @State private var commentInput = "About me"
    @StateObject var vm: PostDetailViewModel
    init(_ postId: Int) {
        self._vm = StateObject(wrappedValue: .init(postId: postId))
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24, content: {
                postView
                Capsule()
                    .frame(height: 2)
                    .fcolor(.XMDesgin.b1)
                    .padding(.horizontal)
                PostCommentListView()
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
                XMUserAvatar(str: AppConfig.mokImage!.absoluteString, userId: 32, size: 32)
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
            if let mod = vm.mod {
                XMLikeBtn(target: PostsOperationAPI.tapLike(postId: vm.postId), isLiked: vm.mod?.isLiked.bool ?? false, likeNumbers: vm.mod?.likeNums ?? 0) { islike in
                    vm.mod?.isLiked = islike.int
                    vm.mod?.likeNums += islike ? 1 : -1
                }

                HStack {
                    Text("\(vm.mod?.commentNums ?? 0)")
                        .font(.XMFont.f3)
                        .bold()
                    XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
                }
            }

            Spacer()

        })
    }

    @ViewBuilder
    var text: some View {
        Text(vm.mod?.postContent ?? "")
            .lineSpacing(3)
            .fcolor(.XMDesgin.f1)
            .font(.XMFont.f1)
            .ifshow(show: vm.mod?.postContent.isEmpty == false)
    }

    var userinfo: some View {
        HStack {
            XMUserAvatar(str: vm.mod?.avatar ?? "", userId: vm.mod?.userId ?? 0, size: 56)
            Text(vm.mod?.nickname ?? "")
                .font(.XMFont.f1b)
                .lineLimit(1)
                .fcolor(.XMDesgin.f1)
            Spacer()
            Text(vm.mod?.createdAtStr ?? "")
                .font(.XMFont.f3)
                .fcolor(.XMDesgin.f2)
        }
    }

    @ViewBuilder
    var images: some View {
        if let atts = vm.mod?.postAttachs, atts.isEmpty == false {
            let urls = atts.map { $0.picUrl }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    Spacer().frame(width: 16 + 38 + 12 - 4)
                    ForEach(urls, id: \.self) { url in

                        XMDesgin.XMButton {
                            Apphelper.shared.tapToShowImage(tapUrl: url, rect: nil, urls: urls)
                        } label: {
                            WebImage(str: url)
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
        } else {
            EmptyView().frame(width: 0, height: 0, alignment: .center)
        }
    }
}

#Preview {
    PostDetailView(1)
}
