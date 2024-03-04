//
//  XMScrollView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/4.
//

import SwiftUI

struct XMStateView<Content : View,loading:View>: View {
    @ViewBuilder var content: () -> Content
    @ViewBuilder var loading: () -> loading
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            content()
        }
    }
    
}

#Preview {
   
    XMStateView {
        RankListView()
    }loading: {
        
    }
}
