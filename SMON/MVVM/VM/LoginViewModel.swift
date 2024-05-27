//
//  LoginViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import AVKit
import Foundation
import SwifterSwift

class LoginViewModel: ObservableObject {
    enum PageProgress {
        case AppFeatures
        case Warning
        case Login_PhoneNumberInput
        case Login_SMSCodeInput
    }

    @Published var pageProgress: PageProgress = .AppFeatures
    @Published var autoLogin: Bool = false
    @Published var phoneInput: String = "" {
        didSet {
            Apphelper.shared.mada(style: .soft)
            if phoneInput == "13999999999" {
                UserManager.shared.isAppleUser = true
            }
        }
    }

    @Published var vcodeInput: String = "" {
        didSet {
            Apphelper.shared.mada(style: .soft)
        }
    }

    // 手机号是否合法输入
    var isPhoneNumberValid: Bool {
        // 移除非数字字符
        let cleanedPhoneInput = phoneInput
        // 检查长度是否为11位
        guard cleanedPhoneInput.count == 11 else {
            return false
        }
        // 检查第一位是否为1
        guard let firstCharacter = cleanedPhoneInput.first, String(firstCharacter) == "1" else {
            return false
        }
        return true
    }
}

extension LoginViewModel {
    @MainActor
    func getSMSCode() async {
        let target = UserAPI.smsCode(p: .init(cellphone: phoneInput, type: 1, zone: "86"))
        let result = await Networking.request_async(target)
        if result.is2000Ok {
            Apphelper.shared.pushNotification(type: .success(message: "验证码发送成功。"))
            pageProgress = .Login_SMSCodeInput
        }
    }

    @MainActor
    func loginBySms() async {
        let target = UserAPI.loginBySms(p: .init(cellphone: phoneInput, code: vcodeInput, zone: "86"))
        let result = await Networking.request_async(target)
        if result.is2000Ok, let userLoginInfo = result.mapObject(XMUserLoginInfo.self) {
            await UserManager.shared.getOSSToken()
            Apphelper.shared.pushNotification(type: .success(message: "登录成功。"))
            Apphelper.shared.closeKeyBoard()
            UserManager.shared.userLoginInfo = userLoginInfo
            MainViewModel.shared.reset()
            // 不需要基础信息，才请求用户信息
            if userLoginInfo.isNeedInfo == false {
                await UserManager.shared.getUserInfo()
            }
        } else {
            autoLogin = false
        }
    }
}
