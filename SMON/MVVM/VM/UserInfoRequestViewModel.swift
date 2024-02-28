//
//  UserInfoRequestViewModel.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/28.
//

import SwiftUI

class UserInfoRequestViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var avatar: UIImage?
    @Published var presentedSteps: [PageStep] = []
    enum PageStep {
        case photo
    }
}
