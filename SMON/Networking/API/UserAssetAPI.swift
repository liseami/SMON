

import KakaJSON
import Moya
import SwiftyJSON

enum UserAssetAPI: XMTargetType {
    case getUserFlamesRecord(page: Int)
    case flamesToHot

    var group: String {
        return "/v1/userAsset"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    func updatingParameters(_ newPage: Int) -> any XMTargetType {
        switch self {
        case .getUserFlamesRecord: return UserAssetAPI.getUserFlamesRecord(page: newPage)
        default: return self
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .flamesToHot: return nil
        case .getUserFlamesRecord(let page): return ["page": page, "pageSize": 10]
        }
    }
}
