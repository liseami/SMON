

import KakaJSON
import Moya
import SwiftyJSON

enum UserAPI: XMTargetType {
    case smsCode(p: SmsCodeReqMod)
    case loginBySms(p: LoginBySmsReqMod)
    case updateUserInfo(p: XMUserUpdateReqMod)
    case getUserInfo(id: String?)
    case albumList(id: String?)
    case updateAlbum(p: [String])
    case getHomePage
    case wallet

    var group: String {
        return "/v1/user"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .wallet : return nil
        case .getHomePage : return nil
        case .updateAlbum(let paths): return ["picPathList": paths]
        case .albumList(let id): return id == nil ? nil : ["userId": id!]
        case .getUserInfo(let id): return id == nil ? nil : ["userId": id!]
        case .smsCode(let p): return p.kj.JSONObject()
        case .loginBySms(let p): return p.kj.JSONObject()
        case .updateUserInfo(let p): return p.kj.JSONObject()
        }
    }
}

extension UserAPI {
    // MARK: - Request

    struct SmsCodeReqMod: Convertible {
        /// 电话号码
        var cellphone: String = ""
        /// 类型，1 注册登录；2 密码重置
        var type: Int = 0
        /// 区号
        var zone: String = ""
    }

    struct LoginBySmsReqMod: Convertible {
        /// 电话号码
        var cellphone: String = ""
        /// 验证码
        var code: String = ""
        /// 区号
        var zone: String = ""
    }
}
