

import KakaJSON
import Moya
import SwiftyJSON

enum CommonAPI: XMTargetType {
    ///  短信验证码注册
    case getUploadToken
    

    var group: String {
        "/v1/common"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        default : return nil
        }
    }
}


