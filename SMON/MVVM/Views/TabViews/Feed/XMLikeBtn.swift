//
//  XMLikeBtn.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import SwiftUI

struct XMLikeBtn: View {
    init(target: XMTargetType, isLiked: Bool, likeNumbers: Int, withLikeNumber: Bool = true,
         onComplete: @escaping (Bool) -> ())
    {
        self.target = target
        self._isLiked = State(initialValue: isLiked)
        self._likeNumbers = State(initialValue: likeNumbers)
        self.withLikeNumber = withLikeNumber
        self.onComplete = onComplete
    }

    let onComplete: (Bool) -> ()
    let withLikeNumber: Bool
    let target: XMTargetType

    @State private var isLiked: Bool
    @State private var likeNumbers: Int

    @MainActor
    func tapLike() async {
        let t = target
        let r = await Networking.request_async(t)
        if r.is2000Ok {
            isLiked.toggle()
            likeNumbers += isLiked ? 1 : -1
            DispatchQueue.main.async {
                onComplete(isLiked)
            }
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
    XMLikeBtn(target: PostsOperationAPI.tapLike(postId: "32"), isLiked: false, likeNumbers: 12, onComplete: { _ in })
}
