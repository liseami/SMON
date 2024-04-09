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

    // 签名，默认为空字符串，可选
    var signature: String?

    // 教育程度，默认为 0，可选
    var education: Int?

    // 微信，默认为空字符串，可选
    var wechat: String?
}

extension XMUserUpdateReqMod {
    init(from profile: XMUserProfile) {
        self.nickname = profile.nickname
        self.avatar = profile.avatar
        self.userAlbum = nil // XMUserProfile 中没有对应的属性
        self.sex = nil // 不可修改
        self.birthday = nil // 不可修改
        self.emotionalNeeds = profile.emotionalNeeds
        self.bdsmAttr = profile.bdsmAttr
        self.interestsTag = profile.interestsTag
        self.height = profile.height
        self.signature = profile.signature
        self.education = profile.education
        self.wechat = profile.wechat
    }
}

struct XMUserLocationInfo: Convertible {
    var lat : String = ""
    var long : String =  ""
}
struct XMUserProfile: Convertible ,Identifiable{
    var id : String = UUID().uuidString
    var userId: String = "" // 一定有，不参与资料完成度评分
    var cityId: String = "" // 一定有，不参与资料完成度评分
    var cityName: String = "" // 一定有，不参与资料完成度评分
    var nickname: String = "" // 一定有，不参与资料完成度评分
    var avatar: String = "" // 一定有，不参与资料完成度评分
    var zodiac: String = "" // 一定有，不参与资料完成度评分
    var birthday: String = "" // 一定有，不参与资料完成度评分
    var signature: String = "" // 不为空，才算完成
    var wechat: String = "" // 不为空，才算完成
    var height: Int = 0 // 不为0，才算完成
    var sex: Int = 0 // 一定有，不参与资料完成度评分
    var interestsTagList: [String] = [] // 不为空，才算完成
    var interestsTag: String {
        interestsTagList.joined(separator: "&")
    }

    var bdsmAttr: Int = 0 // 不为0，才算完成
    var emotionalNeeds: Int = 0 // 不为0，才算完成
    var education: Int = 0 // 不为0，才算完成
    var fansNum: Int = 0 // 一定有，不参与资料完成度评分
    var followsNum: Int = 0 // 一定有，不参与资料完成度评分
    // 1关注对方，0没有关注
    var isFollow: Int = 0
    var isEachOther : Int = 0
}

// 用户资料扩展
extension XMUserProfile {
    // 计算资料完整度分数
    var profileCompletionScore: Double {
        // 初始化“符合规则”的属性数量和总属性数量
        var okAttNumber = 0
        var attNumber = 0

        // 检查签名是否为空
        attNumber += 1
        if !signature.isEmpty {
            okAttNumber += 1
        }

        // 检查微信是否为空
        attNumber += 1
        if !wechat.isEmpty {
            okAttNumber += 1
        }

        // 检查身高是否为零
        attNumber += 1
        if height != 0 {
            okAttNumber += 1
        }

        // 检查兴趣标签列表是否为空
        attNumber += 1
        if !interestsTagList.isEmpty {
            okAttNumber += 1
        }

        // 检查BDSM属性是否为零
        attNumber += 1
        if bdsmAttr != 0 {
            okAttNumber += 1
        }

        // 检查情感需求是否为零
        attNumber += 1
        if emotionalNeeds != 0 {
            okAttNumber += 1
        }

        // 检查教育经历是否为零
        attNumber += 1
        if education != 0 {
            okAttNumber += 1
        }

        // 计算最终分数，已完成的 / 总共参与评分的 * 100
        let finalScore = (Double(okAttNumber) / Double(attNumber))

        // 确保最终分数上限为 100
        return finalScore
    }
}

struct XMUserLoginInfo: Decodable, Encodable, Convertible {
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

extension Int {
    // 获取性别的字符串表示
    var genderString: String {
        switch self {
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
        switch self {
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
        switch self {
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
        switch self {
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

struct XMUserInRank: Identifiable, Convertible {
    var id: String = UUID().uuidString
    var userId: String = "" // : 1764504995815882752,
    var nickname: String = "" // ": "开手机",
    var avatar: String = "" // ": "https://dailycontest.oss-cn-shanghai.aliyuncs.com/app/test/XM_iOS_UserPic_202403071914_7AggIv5rZ9XL.jpg",
    var cityName: String = "" // ": ""
    var distanceStr : String = ""
}
