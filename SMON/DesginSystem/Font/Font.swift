//
//  Font.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import Foundation

extension SwiftUI.Font {
    enum XMFont {
        static let big1: Font = .largeTitle.monospaced()
        static let big2: Font = .title.monospaced()
        static let big3: Font = .title3.monospaced()
        static let f1: Font = .headline.monospaced()
        static let f2: Font = .subheadline.monospaced()
        static let f3: Font = .caption.monospaced()

        static let f1b: Font = .XMFont.f1.bold()
        static let f2b: Font = .XMFont.f2.bold()
        static let f3b: Font = .XMFont.f3.bold()
    }
}

#Preview {
    VStack {
        let text = "设计系统3232"
        Text(text)
            
            .font(.XMFont.big1)
            
        Text(text)
            .font(.XMFont.big2)
        Text(text)

            .font(.XMFont.big3)
        Text(text)
            .font(.XMFont.f1)
        Text(text)
            .font(.XMFont.f2)
        Text(text)
            .font(.XMFont.f3)
        Text(text)
            .font(.XMFont.f1b)
        Text(text)
            .font(.XMFont.f2b)
        Text(text)
            .font(.XMFont.f3b)
    }
}
