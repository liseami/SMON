//
//  XMTag.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/5.
//

import Foundation


struct XMTag : Identifiable {
    var id : String = UUID.init().uuidString
    var text : String
}
