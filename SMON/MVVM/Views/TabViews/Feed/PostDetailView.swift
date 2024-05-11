//
//  PostDetailView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

class PostDetailViewModel: XMModRequestViewModel<XMPostDetail> {
    let postId: String
    init(postId: String) {
        self.postId = postId
        super.init(pageName: "") {
            PostAPI.detail(postId: postId, userId: UserManager.shared.user.userId)
        }
    }

    @Published var inputStr: String = ""
    @Published var commentTargetInfo: XMPostComment?

    /*
     发表评论和回复
     */
    @MainActor
    func addCommentToPost() async {
        guard self.inputStr.isEmpty == false else { return }

        var mod = PostsOperationAPI.CommentReqMod()
        if let commentTargetInfo {
            // 给评论回复
            mod.commentId = commentTargetInfo.id
            mod.toUserId = commentTargetInfo.userId
        } else {
            // 给帖子回复
            mod.toUserId = self.mod.userId
        }
        mod.postId = self.postId
        mod.content = self.inputStr

        let t = PostsOperationAPI.comment(p: mod)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            DispatchQueue.main.async {
                // 新增评论
                if let obj = r.mapObject(XMPostComment.self){
                    if obj.commentNum == nil ,let newReply = r.mapObject(XMPostReply.self){
                        NotificationCenter.default.post(name:
                            Notification.Name.ADD_NEW_REPLEY_SUCCESS, object: newReply)
                    }else{
                        NotificationCenter.default.post(name: Notification.Name.ADD_NEW_COMMENT_SUCCESS, object: obj)
                    }
                }
            }
            self.inputStr.removeAll()
            Apphelper.shared.closeKeyBoard()
            // 请求详情
        }
    }

    @MainActor
    func deletePost() async {
        let t = PostAPI.delete(postId: self.postId, userId: self.mod.userId)
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            MainViewModel.shared.pageBack()
        }
    }
}

struct PostDetailView: View {
    @StateObject var vm: PostDetailViewModel
    init(_ postId: String) {
        self._vm = StateObject(wrappedValue: .init(postId: postId))
    }

    @State var passwordText: String = ""
    @FocusState var focused {
        didSet {
            if self.focused == false {
                self.vm.inputStr.removeAll()
            }
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24, content: {
                // 详情
                postView
                // 细线
                Capsule()
                    .frame(height: 2)
                    .fcolor(.XMColor.b1)
                    .padding(.horizontal)
                // 评论列表
                PostCommentListView(postId: vm.postId, focused: $focused)
                    .environmentObject(vm)
                Spacer().frame(height: 120)
            })
            .padding(.horizontal, 16)
        }
        .refreshable {
            self.vm.mod = .init()
            await vm.getSingleData()
        }
        .scrollDismissesKeyboard(.immediately)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                XMDesgin.XMButton {
                    let actions = vm.mod.userId == UserManager.shared.user.userId ?
                        [
                            UIAlertAction(title: "删除", style: .destructive, handler: { _ in
                                Task {
                                    await vm.deletePost()
                                }
                            }),
                        ] : [UIAlertAction(title: "举报内容", style: .default, handler: { _ in
                            Task {
                                await Apphelper.shared.report(type: .post, reportValue: vm.mod.id)
                            }
                        }),
                        UIAlertAction(title: "拉黑用户 / 不再看他", style: .destructive, handler: { _ in
                            /*
                             拉黑用户
                             */
                            Apphelper.shared.blackUser(userid: self.vm.mod.userId)
                        })]
                    Apphelper.shared.pushActionSheet(title: "操作", message: "", actions: actions)
                } label: {
                    XMDesgin.XMIcon(iconName: "system_more", size: 16, withBackCricle: true)
                }
            }
        })
        .navigationTitle("详情")
        .overlay(alignment: .bottom) {
            commentInpuBar
        }
    }

    var commentInpuBar: some View {
        VStack(alignment: .center, spacing: 0, content: {
            HStack(alignment: .top) {
                XMUserAvatar(str: UserManager.shared.user.avatar, userId: UserManager.shared.user.userId, size: 32)
                    .padding(.top, 6)
                TextField(text: $vm.inputStr, prompt: Text(vm.commentTargetInfo == nil ? "说点什么？" : "回复：@" + vm.commentTargetInfo!.nickname), label: {})
                    .lineLimit(...(focused ? 4 : 1))
                    .tint(.XMColor.main)
                    .font(.XMFont.f2)
                    .focused($focused)
                    .padding(.all, 12)
                    .background(.XMColor.b1)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                XMDesgin.SmallBtn(fColor: .XMColor.f1, backColor: .XMColor.main, iconName: "", text: "发送") {
                    await vm.addCommentToPost()
                }
                .padding(.top, 6)
                .transition(.movingParts.pop(Color.XMColor.main))
                .ifshow(show: focused)
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
            if vm.reqStatus == .isOK {
                XMLikeBtn(target: PostsOperationAPI.tapLike(postId: vm.postId),
                          isLiked: vm.mod.isLiked.bool,
                          likeNumbers: vm.mod.likeNums,
                          contentId: vm.mod.id)

                HStack {
                    Text("\(vm.mod.commentNums)")
                        .font(.XMFont.f3)
                        .bold()
                    XMDesgin.XMIcon(iconName: "feed_comment", size: 16, withBackCricle: true)
                }
                Spacer()
            } else {
                ProgressView()
            }
        })
    }

    @ViewBuilder
    var text: some View {
        Text(vm.mod.postContent)
            .lineSpacing(3)
            .fcolor(.XMColor.f1)
            .font(.XMFont.f1)
            .ifshow(show: vm.mod.postContent.isEmpty == false)
    }

    var userinfo: some View {
        HStack {
            XMUserAvatar(str: vm.mod.avatar, userId: vm.mod.userId, size: 56)
            Text(vm.mod.nickname)
                .font(.XMFont.f1b)
                .lineLimit(1)
                .fcolor(.XMColor.f1)
            Spacer()
            Text(vm.mod.createdAtStr)
                .font(.XMFont.f3)
                .fcolor(.XMColor.f2)
        }
    }

    @ViewBuilder
    var images: some View {
        if vm.mod.postAttachs.isEmpty == false {
            let urls = vm.mod.postAttachs.map { $0.picUrl }
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
    PostDetailView("1")
}
