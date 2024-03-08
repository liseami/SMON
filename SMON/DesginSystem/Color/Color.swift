//
//  Color.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/27.
//

import Foundation
import SwiftUI

extension Color {
    enum XMDesgin {
        static let f1: Color = .init(hex: "FEFEFE")
        static let f2: Color = .init(hex: "999999")
        static let f3: Color = .init(hex: "7F7F7F")
        static let b1: Color = .init(hex: "191919")
        static let b2: Color = .init(hex: "666666")
        static let b3: Color = .init(hex: "7F7F7F")
        static let main : Color = .init(hex: "AA7E1F")
    }
}
extension View{
    func fcolor(_ color : Color) -> some View  {
        self.foregroundStyle(color)
    }
}
