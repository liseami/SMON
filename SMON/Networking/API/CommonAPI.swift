

import KakaJSON
import Moya
import SwiftyJSON

enum CommonAPI: XMTargetType {
    ///  短信验证码注册
    case getUploadToken
    case interests
    case getImUserSign

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
        
        get{
            switch self {
            default: return nil
            }
        }
        set{
          
        }
    }
}
