

import KakaJSON
import Moya
import SwiftyJSON

enum CommonAPI: XMTargetType {
    ///  短信验证码注册
    case getUploadToken
    case interests
    case getImUserSign
    case versionInfo(lat: String, lon: String)

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
        case .versionInfo(let lat ,let lon) : return nil
        default: return nil
        }
    }
}
