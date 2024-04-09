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
        VStack(spacing: 12) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            Text(text)
                .font(.XMFont.f1)
                .fcolor(.XMDesgin.f2)
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
