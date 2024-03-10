//
//  BlackListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/10.
//

import SwiftUI

struct BlackListView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(alignment: .leading, spacing: 24, pinnedViews: [], content: {
                ForEach(0 ... 120, id: \.self) { _ in
                    XMUserLine()
                }
            })
            .padding(.all, 16)
        })
        .navigationTitle("黑名单")
    }
}

#Preview {
    BlackListView()
}
