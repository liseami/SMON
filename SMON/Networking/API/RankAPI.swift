

import KakaJSON
import Moya
import SwiftyJSON

enum RankAPI: XMTargetType {
    case country(page: Int)

    var parameters: [String: Any]? {
        switch self {
        case .country(let page): return ["page": page,"pageSize" : 20]
        default: return nil
        }
    }

    func updatingParameters(_ newPage: Int) -> any XMTargetType {
        switch self {
        case .country: return RankAPI.country(page: newPage)
        }
    }
    var group: String {
        return "/v1/rank"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }
}
