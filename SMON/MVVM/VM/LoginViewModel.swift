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
