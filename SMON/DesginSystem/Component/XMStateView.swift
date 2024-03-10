//
//  XMScrollView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/4.
//

import SwiftUI

struct XMStateView<Content: View, Loading: View, Empty: View>: View {
    var reqStatus: XMRequestStatus
    @ViewBuilder var content: () -> Content
    @ViewBuilder var loading: () -> Loading
    @ViewBuilder var empty: () -> Empty
    
    init(reqStatus: XMRequestStatus, @ViewBuilder content: @escaping () -> Content, @ViewBuilder loading: @escaping () -> Loading = {
        ProgressView()
            .padding(.top, UIScreen.main
                .bounds.height * 0.3)
            .frame(height: UIScreen.main
                .bounds.height, alignment: .top)
    }, @ViewBuilder empty: @escaping () -> Empty = { XMEmptyView() }) {
        self.reqStatus = reqStatus
        self.content = content
        self.loading = loading
        self.empty = empty
    }

    var body: some View {
        
        
        switch reqStatus {
        case .isLoading:
            loading()
                .transition(.opacity.animation(.easeOut(duration: 0.2)))
                .frame(maxWidth:.infinity)
        case .isNeedReTry:
            VStack {
                Image("networkerror_pagepic")
                Text("网络错误，请刷新重试。")
                    .font(.XMFont.f1)
            }
            .padding(.top, UIScreen.main
                .bounds.height * 0.3)
            .frame(height: UIScreen.main
                .bounds.height, alignment: .top)
            .frame(maxWidth:.infinity)
        case .isOK:
            content()
                .transition(.opacity.animation(.easeOut(duration: 0.2)))
        case .isOKButEmpty:
            empty()
                .frame(maxWidth:.infinity)
        }
    }
}

#Preview {
    XMStateView(reqStatus: .isOKButEmpty, content: {}, loading: {
        ProgressView()
    }, empty: {
        Text("空页面")
    })
}
