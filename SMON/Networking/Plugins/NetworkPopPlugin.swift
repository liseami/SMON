//
//  WarningPlugin.swift
//  FantasyChat
//
//  Created by 赵翔宇 on 2022/8/1.
//

import Foundation
import Moya
import Alamofire

/// 通用网络插件
public class NetworkPopPlugin: PluginType {
    /// 开始请求字典

    public init() {}

    /// 即将发送请求
    public func willSend(_: RequestType, target: TargetType) {
        #if DEBUG
            // 设置当前时间

        #endif
    }

    /// 收到请求时
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        switch result {
//        case .success:
//            if result.messageCode == 401 {
//                UserManager.shared.logOut()
//                pushPop("登录超时，请重新登录。", style: .warning, alignment: .top)
//            }
//            if result.messageCode != 200, result.messageCode != 0 {
//                guard UserManager.shared.logged else { return }
//                pushPop(result.message.or("未知错误。"), style: .warning)
//            }
//        case .failure:
//            pushPop("网络错误。请检查网络后重试。", style: .danger, alignment: .top)
//        }
    }
}
