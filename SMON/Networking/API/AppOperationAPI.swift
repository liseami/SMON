

import KakaJSON
import Moya
import SwiftyJSON

enum AppOperationAPI: XMTargetType {
    
    case dailySignIn

    var group: String {
        return "/v1/appOperation"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        return nil
    }
}
