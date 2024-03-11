//
//  Font.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import Foundation

extension SwiftUI.Font {
    enum XMFont {
        static let big1: Font = .custom("GenSekiGothic-L", relativeTo: .largeTitle)
        static let big2: Font = .title.monospaced()
        static let big3: Font = .title3.monospaced()
        static let f1: Font = .body.weight(.regular)
        static let f2: Font = .subheadline.monospaced()
        static let f3: Font = .caption.monospaced()

        static let f1b: Font = .headline.monospaced().bold()
        static let f2b: Font = .subheadline.monospaced().bold()
        static let f3b: Font = .caption.monospaced().bold()
    }
}

#Preview {
    VStack(spacing:24) {
        let text = "设计系统3232"
        Text(text)
            .font(.XMFont.big1)
        Text(text)
            .font(.XMFont.big2)
        Text(text)
            .font(.XMFont.big3)
        Divider()
        Text(text)
            .font(.XMFont.f1)
        Text(text)
            .font(.XMFont.f1b)
        Text(text)
            .font(.XMFont.f2)
        Text(text)
            .font(.XMFont.f2b)
        Text(text)
            .font(.XMFont.f3)
        Text(text)
            .font(.XMFont.f3b)
    }
}
