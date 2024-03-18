//
//  PostCommentListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import SwiftUI
// class PostCommentListViewModel : XMListViewModel<> {
//
// }
struct PostCommentListView: View {
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
            ForEach(1 ... 120, id: \.self) { _ in
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
}

#Preview {
    PostCommentListView()
}
