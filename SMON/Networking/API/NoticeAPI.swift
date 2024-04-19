

import KakaJSON
import Moya
import SwiftyJSON

enum NoticeAPI: XMTargetType {
    case setting(p: NotificationSetting)
    case getSettingInfo
    case dynamicList(page: Int)

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
        case .dynamicList(let page): return ["page": page, "pageSize": 30]
        case .setting(let p): return p.kj.JSONObject()
        default: return nil
        }
    }

    func updatingParameters(_ newPage: Int) -> any XMTargetType {
        switch self {
        case .dynamicList(let page): return NoticeAPI.dynamicList(page: newPage)
        default: return self
        }
    }
}
