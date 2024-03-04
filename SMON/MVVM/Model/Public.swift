//
//  Public.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/23.
//

import Foundation
import KakaJSON

struct LabelInfo {
    var name: String
    var icon: String
    var subline: String
}


struct SettingItem {
    var name: String
    var iconName : String?
    var children: [SettingItem]? = []
}


struct XMUserOSSTokenInfo:Encodable, Decodable, Convertible {
    /// OSS服务的访问端点
    var endpoint: String = ""
    /// 访问密钥ID
    var accessKeyId: String = ""
    /// 访问密钥秘钥
    var accessKeySecret: String = ""
    /// 安全令牌
    var securityToken: String = ""
    /// 过期时间戳
    var expiration: TimeInterval = 0
}


// 省份
struct Province: Convertible {
    let id: String = ""
    let name: String = ""
    let children: [City] = []
}

// 城市
struct City: Convertible {
    let id: String = ""
    let name: String = ""
    let location: String = ""
}
