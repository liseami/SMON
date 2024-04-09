

import KakaJSON
import Moya
import SwiftyJSON

enum RankAPI: XMTargetType {
    case country(page: Int)
    case sameCity(cityId: Int, page: Int)
    case nearby(page: Int, fliter: FliterMod)
    case fans(page: Int)
    case follow(page: Int)
    case visitor(page: Int)

    var parameters: [String: Any]? {
        switch self {
        case .sameCity(let cityId, let page): return ["page": page, "pageSize": 50, "cityId": cityId]
        case .country(let page): return ["page": page, "pageSize": 50]
        case .fans(let page): return ["page": page, "pageSize": 50]
        case .follow(let page): return ["page": page, "pageSize": 50]
        case .visitor(let page): return ["page": page, "pageSize": 50]
        case .nearby(let page, let fliter):
            return ["page": page] +
                ["latitude": UserManager.shared.userlocation.lat, "longitude": UserManager.shared.userlocation.long]
                + fliter.kj.JSONObject()
        }
    }

    func updatingParameters(_ newPage: Int) -> any XMTargetType {
        switch self {
        case .nearby(_, let fliter): return RankAPI.nearby(page: newPage, fliter: fliter)
        case .fans: return RankAPI.fans(page: newPage)
        case .follow: return RankAPI.follow(page: newPage)
        case .visitor: return RankAPI.visitor(page: newPage)
        case .sameCity(let cityId, _): return RankAPI.sameCity(cityId: cityId, page: newPage)
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
