//
//  XMTag.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/5.
//

import Foundation


struct XMTag: Identifiable, Convertible {
    var id: String = UUID().uuidString
    var text: String = ""
}

struct XMTagGroup:Hashable, Convertible {
    var id: String = ""
    var title: String = ""
    var children: [String] = []
}
