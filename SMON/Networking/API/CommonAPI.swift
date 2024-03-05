

import KakaJSON
import Moya
import SwiftyJSON

enum CommonAPI: XMTargetType {
    ///  短信验证码注册
    case getUploadToken
    case interests
    case getImUserSign

    var group: String {
        switch self {
        case .interests:
            "/v1/common/tag"
        default:
            "/v1/common"
        }
    }

    var method: HTTPRequestMethod {
        switch self {
        case .interests: return .get
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        default: return nil
        }
    }
}
