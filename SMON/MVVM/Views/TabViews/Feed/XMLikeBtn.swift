//
//  XMLikeBtn.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import SwiftUI

struct XMLikeBtn: View {
    init(target: XMTargetType,
         isLiked: Bool,
         likeNumbers: Int,
         withLikeNumber: Bool = true,
         contentId: String)
    {
        self.target = target
        self.contentId = contentId
        self._isLiked = State(initialValue: isLiked)
        self._likeNumbers = State(initialValue: likeNumbers)
        self.withLikeNumber = withLikeNumber
    }

    let withLikeNumber: Bool
    let target: XMTargetType

    let contentId: String
    @State private var isLiked: Bool
    @State private var likeNumbers: Int
    @State var imTapSelf : Bool  = false

    @MainActor
    func tapLike() async {
        let t = target
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            isLiked.toggle()
            likeNumbers += isLiked ? 1 : -1
            imTapSelf = true
            NotificationCenter.default.post(name: Notification.Name.PostTapLike, object: nil, userInfo: ["postId": contentId])
        }
    }

    var body: some View {
        HStack {
            Text("\(self.likeNumbers)")
                .font(.XMFont.f3)
                .bold()
                .ifshow(show: withLikeNumber)
            XMDesgin.XMButton {
                await self.tapLike()
            } label: {
                XMDesgin.XMIcon(
                    iconName: self.isLiked ? "feed_heart_fill" : "feed_heart",
                    size: 16,
                    color: self.isLiked ? .red : .XMDesgin.f1,
                    withBackCricle: true)
            }
            // 在详情内被点赞，列表中响应。
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name.PostTapLike, object: nil)) { notification in
                if let postId = notification.userInfo?["postId"] as? String {
                    guard postId == contentId, self.imTapSelf == false else {
                        self.imTapSelf = false
                        return }
                    DispatchQueue.main.async {
                        self.isLiked.toggle()
                        self.likeNumbers += self.isLiked ? 1 : -1
                    }
                }
            }
            .changeEffect(.spray {
                Group {
                    XMDesgin.XMIcon(iconName: "feed_heart_fill", color: .red)
                    Image(systemName: "sparkles")
                }
                .font(.title)
                .foregroundStyle(.red.gradient)
            }, value: isLiked, isEnabled: isLiked)
        }
    }
}

#Preview {
    XMLikeBtn(target: PostsOperationAPI.tapLike(postId: "32"), isLiked: false, likeNumbers: 12, contentId: "")
}
