//
//  FeedListView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/2.
//

import SwiftUI

struct PostListView: View {
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [], content: {
                ForEach(0 ... 120, id: \.self) { _ in
                    PostView()
                }
            })
            .padding(.all, 16)
        }
        .refreshable {}
    }
}

#Preview {
    PostListView()
        
}
