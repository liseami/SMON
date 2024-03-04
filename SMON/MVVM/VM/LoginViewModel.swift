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
        case Login
    }

    @Published var pageProgress: PageProgress = .AppFeatures
    @Published var phoneInput: String = ""
    @Published var vcodeInput: String = ""
    @Published var showCodeInputView: Bool = false
    var isPhoneNumberValid: Bool {
        guard phoneInput.isDigits, phoneInput.count == 11 else {
            return false // Check if the length is 11 digits
        }

        guard let firstCharacter = phoneInput.first, String(firstCharacter) == "1" else {
            return false // Check if it starts with "1"
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
            showCodeInputView = true
        }
    }

    @MainActor
    func loginBySms() async {
        let target = UserAPI.loginBySms(p: .init(cellphone: phoneInput, code: vcodeInput, zone: "86"))
        let result = await Networking.request_async(target)
        if result.is2000Ok {
            Apphelper.shared.pushNotification(type: .success(message: "登录成功。"))
            if let user = result.mapObject(XMUser.self) {
                UserManager.shared.user = user
                Apphelper.shared.closeKeyBoard()
                MainViewModel.shared.reset()
            }
        }
    }
}
