

import KakaJSON
import Moya
import SwiftyJSON

enum NoticeAPI: XMTargetType {
    case setting(p: NotificationSetting)
    case getSettingInfo

    var group: String {
        return "/v1/notice"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .setting(let p): return p.kj.JSONObject()
        default: return nil
        }
    }
}
