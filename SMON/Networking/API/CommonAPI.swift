

import KakaJSON
import Moya
import SwiftyJSON

enum CommonAPI: XMTargetType {
    ///  短信验证码注册
    case getUploadToken
    case interests
    case getImUserSign
    case versionInfo(lat: String, lon: String)
    case faceAuth(realName: String, idNo: String)
    case faceAuthVerify(orderNo: String)
    var group: String {
        return "/v1/common"
    }

    var method: HTTPRequestMethod {
        switch self {
        case .interests: return .get
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .faceAuthVerify(let orderNo): return ["orderNo": orderNo]
        case .faceAuth(let realName, let idNo): return ["realName": realName, "idNo": idNo]
        case .versionInfo(let lat, let lon): return lat.isEmpty ? nil : ["lat": lat, "lon": lon]
        default: return nil
        }
    }
}
