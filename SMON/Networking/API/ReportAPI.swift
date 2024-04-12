

import KakaJSON
import Moya
import SwiftyJSON

enum ReportAPI: XMTargetType {
    case report(type: Int, reportValue: String)

    var group: String {
        return "/v1/report"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .report(let type, let reportValue): return ["reportType": type, "reportValue": reportValue]
        default: return nil
        }
    }
}
