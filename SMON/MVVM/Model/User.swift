//
//  User.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/4.
//

import Foundation
import KakaJSON

struct XMUser: Decodable, Encodable, Convertible {
    var userId: String = ""
    var token: String = ""
    var isNeedInfo: Bool = true
}

extension XMUser {
    var isLogin: Bool {
        !token.isEmpty
    }
}
