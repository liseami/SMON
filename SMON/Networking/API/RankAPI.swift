

import KakaJSON
import Moya
import SwiftyJSON

enum RankAPI: XMTargetType {
    var parameters: [String : Any]?{
        get{
            switch self {
            default: return nil
            }
        }
        set{}
    }
    
    case country

    var group: String {
        return "/v1/rank"
    }

    var method: HTTPRequestMethod {
        switch self {
        default: return .post
        }
    }

    
}
