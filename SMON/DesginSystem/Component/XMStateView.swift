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
    var body: some View {
        switch reqStatus {
        case .isLoading:
            loading()
        case .isNeedReTry:
            VStack {
                Image("networkerror_pagepic")
                Text("网络错误，请刷新重试。")
                    .font(.XMFont.f1)
            }
        case .isOK:
            content()
        case .isOKButEmpty:
            VStack {
                Image("emptydata_pagepic")
                Text("暂时没有内容")
                    .font(.XMFont.f1)
            }
        }
    }
}

#Preview {
    XMStateView(reqStatus: .isOKButEmpty, content: { 

    }, loading: {
        ProgressView()
    }, empty: {
        Text("空页面")
    })
}
