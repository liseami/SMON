

import KakaJSON
import Moya
import SwiftyJSON

extension GiftAPI {
    struct GiftSendReqMod: Convertible {
        var incomeUserId: String = "" // 1764504995815882752,
        var sceneId: String = "" // ": 1,
        var sceneValue: String = "" // ": 1764504995815882752,
        var giftId: String = "" // ": 1,
        var giftNum: String = "" // ": 1
    }
}

enum GiftAPI: XMTargetType {
    case giftsReceivedList(page: Int)
    case giftList(page: Int,sceneId:String)
    case gift(p: GiftSendReqMod)

    var group: String {
        return "/v1/gifts"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    func updatingParameters(_ newPage: Int) -> any XMTargetType {
        switch self {
        case .giftsReceivedList: return GiftAPI.giftsReceivedList(page: newPage)
        case .giftList(let page ,let sceneId): return GiftAPI.giftList(page: newPage,sceneId: sceneId)
        default: return self
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .gift(let p): return p.kj.JSONObject()
        case .giftsReceivedList(let page): return ["page": page, "pageSize": 20]
        case .giftList(let page,let sceneId): return ["page": page, "pageSize": 20,"sceneId":sceneId]
        default: return nil
        }
    }
}
