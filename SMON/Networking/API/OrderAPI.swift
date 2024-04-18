

import KakaJSON
import Moya
import SwiftyJSON

enum OrderAPI: XMTargetType {
    case iosPayVerify(transactionId: String, receipt: String, orderId: String)
    case placeOrder(payType: Int, goodsId: String)
    var group: String {
        return "/v1/order"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .placeOrder(let payType, let goodsId): return ["payType": payType, "goodsId": goodsId]
        case .iosPayVerify(let transactionId, let receipt, let orderId): return ["transactionId": transactionId, "receipt": receipt, "orderId": orderId]
        default: return nil
        }
    }
}
