//
//  LoginViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import AVKit
import Foundation

class LoginViewModel: ObservableObject {
    enum PageProgress {
        case AppFeatures
        case Warning
        case Login
    }

    @Published var pageProgress: PageProgress = .AppFeatures

 
}
