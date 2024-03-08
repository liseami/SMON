//
//  MyFriendsView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/1.
//

import SwiftUI

struct RelationListView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            HStack(alignment: .center, content: {
                Text("朋友")
                    .bold()
                    .frame(maxWidth:.infinity)
                Text("粉丝")
                    .opacity(0.6)
                    .frame(maxWidth:.infinity)
                Text("关注")
                    .opacity(0.6)
                    .frame(maxWidth:.infinity)
            })
            .padding(.vertical,12)
            .font(.XMFont.f1b)
            .overlay(alignment: .bottom) {
                Divider()
            }
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                    ForEach(0 ... 120, id: \.self) { _ in
                        XMUserLine()
                    }
                })
                .padding(.all, 16)
            })
        })
        .navigationTitle("朋友")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RelationListView()
}

struct XMUserLine: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            WebImage(str: AppConfig.mokImage!.absoluteString)
                .scaledToFill()
                .frame(width: 44, height: 44, alignment: .center)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 12, content: {
                HStack {
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text("Placeholder")
                            .font(.XMFont.f1b)
                        Text("天蝎 · S")
                            .font(.XMFont.f2)
                            .fcolor(.XMDesgin.f2)
                    })
                    Spacer()
                    XMDesgin.SmallBtn(fColor: .XMDesgin.f1, backColor: .XMDesgin.b1, iconName: "", text: "正在关注") {}
                }
                Text(String.randomChineseString(length: 40))
                    .font(.XMFont.f2)

            })
        }
        .onTapGesture {
            MainViewModel.shared.pathPages.append(.profile(userId: ""))
        }
    }
}
