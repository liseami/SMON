//
//  Font.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import Foundation

extension SwiftUI.Font {
    enum XMFont {
        static let big1: Font = .custom("GenSekiGothicTW-M", relativeTo: .largeTitle)
        static let big2: Font = .custom("GenSekiGothicTW-M", relativeTo: .title)
        static let big3: Font = .custom("GenSekiGothicTW-M", relativeTo: .title3)
        static let f1: Font = .custom("GenSekiGothicTW-M", relativeTo: .body)
        static let f2: Font = .custom("GenSekiGothicTW-M", relativeTo: .subheadline)
        static let f3: Font = .custom("GenSekiGothicTW-M", relativeTo: .caption)
        static let f1b: Font = .custom("GenSekiGothicTW-B", relativeTo: .body)
        static let f2b: Font = .custom("GenSekiGothicTW-B", relativeTo: .subheadline)
        static let f3b: Font = .custom("GenSekiGothicTW-B", relativeTo: .caption)
    }
}

#Preview {
    VStack(spacing: 24) {
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
