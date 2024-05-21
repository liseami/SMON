

import KakaJSON
import Moya
import SwiftyJSON

enum UserOperationAPI: XMTargetType {
    case sayHello(toUserId: String)
    case tapUserLike(likeUserId: String)

    var group: String {
        return "/v1/userOperation"
    }

    var method: HTTPRequestMethod {
        return .post
    }

    var parameters: [String: Any]? {
        switch self {
        case .sayHello(let id): return ["toUserId": id]
        case .tapUserLike(let id): return ["likeUserId": id]
        default: return nil
        }
    }
}
