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

