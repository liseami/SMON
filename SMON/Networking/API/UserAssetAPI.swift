

import KakaJSON
import Moya
import SwiftyJSON

enum UserAssetAPI: XMTargetType {
    case getUserFlamesRecord(page: Int)
    case flamesToHot
    case hotInfo
    case getHotRecord(page: Int)
    case billRecord(page: Int)
    case coinToHot(coin: Int)

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
        case .billRecord: return UserAssetAPI.billRecord(page: newPage)
        case .getUserFlamesRecord: return UserAssetAPI.getUserFlamesRecord(page: newPage)
        case .getHotRecord: return UserAssetAPI.getHotRecord(page: newPage)
        default: return self
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .coinToHot(let coin): return ["coin": coin]
        case .billRecord(let page): return ["page": page, "pageSize": 20]
        case .getUserFlamesRecord(let page): return ["page": page, "pageSize": 20]
        case .getHotRecord(let page): return ["page": page, "pageSize": 20]
        default: return nil
        }
    }
}
