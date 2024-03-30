

import KakaJSON
import Moya
import SwiftyJSON

enum GoodAPI: XMTargetType {
    case getCoinList


    var group: String {
        return "/v1/goods"
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
