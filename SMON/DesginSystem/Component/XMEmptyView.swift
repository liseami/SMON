//
//  XMEmptyView.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/9.
//

import SwiftUI

struct XMEmptyView: View {
    let image: String
    let text: String
    init(image: String = "emptydata_pagepic", text: String = "暂时没有内容") {
        self.image = image
        self.text = text
    }

    var body: some View {
        VStack {
            Image(image)
            Text(text)
                .font(.XMFont.f1)
        }
        .padding(.top, UIScreen.main
            .bounds.height * 0.3)
        .frame(height: UIScreen.main
            .bounds.height, alignment: .top)
    }
}

#Preview {
    XMEmptyView()
}
