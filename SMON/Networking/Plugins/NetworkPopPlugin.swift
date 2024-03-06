//
//  WarningPlugin.swift
//  FantasyChat
//
//  Created by 赵翔宇 on 2022/8/1.
//

import Alamofire
import Foundation
import Moya

/// 通用网络插件
public class NetworkPopPlugin: PluginType {
    public init() {}

    /// 即将发送请求
    public func willSend(_: RequestType, target: TargetType) {}

    /// 收到请求时
    @MainActor 
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success:
            if !result.is2000Ok {
                Apphelper.shared.pushNotification(type: .error(message: result.message.or("未知错误。")))
            }
            
            if result.messageCode > 4000 || result.message == "TOKEN 错误" {
                UserManager.shared.userLoginInfo = .init()
                Apphelper.shared.closeKeyBoard()
                Apphelper.shared.pushNotification(type: .info(message: result.message.or("登录过期，请重新登录。")))
            }
            
        case .failure:
            Apphelper.shared.pushNotification(type: .error(message: result.message.or("网络错误。")))
        }
    }
}
