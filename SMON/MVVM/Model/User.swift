//
//  User.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/4.
//

import Foundation
import KakaJSON

struct XMUserUpdateReqMod: Decodable, Encodable, Convertible {
    // 昵称，默认为空字符串，可选
    var nickname: String?

    // 头像，默认为空字符串，可选
    var avatar: String?

    // 用户相册，默认为空数组，可选
    var userAlbum: [String]?

    // 性别，默认为 0（表示未知或未设置），可选
    var sex: Int?

    // 生日，默认为空字符串，可选
    var birthday: String?

    // 情感需求，默认为 0，可选
    var emotionalNeeds: Int?

    // BDSM 属性，默认为 0，可选
    var bdsmAttr: Int?

    // 兴趣标签，默认为空字符串，可选
    var interestsTag: String?

    // 身高，默认为 0，可选
    var height: Int?

    // 体重，默认为 0，可选
    var weight: Int?

    // 签名，默认为空字符串，可选
    var signature: String?

    // 教育程度，默认为 0，可选
    var education: Int?

    // 微信，默认为空字符串，可选
    var wechat: String?
}



struct XMUserProfile: Codable, Convertible, XMIntToStringProtocol {
    var userId: Int = 0
    var cityId: String = ""
    var cityName: String = ""
    var nickname: String = ""
    var avatar: String = ""
    var zodiac: String = ""
    var birthday: String = ""
    var signature: String = ""
    var wechat: String = ""
    var sex: Int = 0
    var bdsmAttr: Int = 0
    var emotionalNeeds: Int = 0
    var education: Int = 0
    var fansNum: Int = 0
    var followsNum: Int = 0
}



struct XMUserLoginInfo: Decodable, Encodable, Convertible, XMIntToStringProtocol {
    var isLogin: Bool {
        !token.isEmpty
    }

    // 用户 ID，默认为空字符串
    var userId: String = ""

    // 令牌，默认为空字符串
    var token: String = ""

    // 是否需要信息，默认为 true
    var isNeedInfo: Bool = true

    // 昵称，默认为空字符串
    var nickname: String = ""

    // 头像，默认为空字符串
    var avatar: String = ""

    // 用户相册，默认为空数组
    var userAlbum: [String] = []

    // 性别，默认为 0（表示未知或未设置）
    var sex: Int = 0

    // 生日，默认为 "0001-01-01"
    var birthday: String = ""

    // 情感需求，默认为 0
    var emotionalNeeds: Int = 0

    // BDSM 属性，默认为 0
    var bdsmAttr: Int = 0

    // 兴趣标签，默认为空字符串
    var interestsTag: String = ""

    // 身高，默认为 0
    var height: Int = 0

    // 体重，默认为 0
    var weight: Int = 0

    // 签名，默认为空字符串
    var signature: String = ""

    // 教育程度，默认为 0
    var education: Int = 0

    // 微信，默认为空字符串
    var wechat: String = ""
}


protocol XMIntToStringProtocol {
    var education: Int { get }
    var sex: Int { get }
    var bdsmAttr: Int { get }
    var emotionalNeeds: Int { get }
    
}

extension XMIntToStringProtocol {
    // 获取性别的字符串表示
    var genderString: String {
        switch sex {
        case 1:
            return "男"
        case 2:
            return "女"
        default:
            return "未知"
        }
    }

    // 获取BDSM属性的字符串表示
    var bdsmAttrString: String {
        switch bdsmAttr {
        case 1:
            return "Dom"
        case 2:
            return "Sado"
        case 3:
            return "Sub"
        case 4:
            return "Maso"
        default:
            return "不确定"
        }
    }

    // 获取情感需求的字符串表示
    var emotionalNeedsString: String {
        switch emotionalNeeds {
        case 1:
            return "长期关系"
        case 2:
            return "自由无束缚"
        default:
            return "不确定"
        }
    }

    // 获取教育程度的字符串表示
    var educationString: String {
        switch education {
        case 1:
            return "高中"
        case 2:
            return "中专"
        case 3:
            return "大学"
        case 4:
            return "研究生"
        case 5:
            return "博士"
        default:
            return "不愿透露"
        }
    }
}
