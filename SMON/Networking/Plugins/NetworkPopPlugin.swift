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

            let tokenError = result.messageCode > 4000

            if tokenError {
                guard UserManager.shared.logged else { return }
                UserManager.shared.userLoginInfo = .init()
                Apphelper.shared.closeKeyBoard()
                Apphelper.shared.pushNotification(type: .info(message: "登录过期，请重新登录。"))
            }

            
            if result.messageCode == 2100{
                Apphelper.shared.present(MemberShipView(), presentationStyle: .overFullScreen)
            }

            if !result.is2000Ok && result.code < 4000 {
                Apphelper.shared.pushNotification(type: .error(message: result.message.or("未知错误。")))
            }

        case .failure:
            guard UserManager.shared.logged else { return }
            Apphelper.shared.pushNotification(type: .error(message: result.message.or("网络错误。")))
        }
    }
}
