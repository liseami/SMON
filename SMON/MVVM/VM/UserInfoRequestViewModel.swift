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
    @Published var morePhoto : [UIImage] = []
    @Published var presentedSteps: [PageStep] = []
    @Published var brithday : Date = .now
    @Published var gender : Int = 0
    @Published var relationHope : Int = 0
    @Published var showCompleteView : Bool = false
    enum PageStep :CaseIterable {
        case photo
        case morephoto
        case brithday
        case sex
        case relationhope
        case hobby
        case height
        case drink
        case smoke
        case bio
        case bdsm
        
    }
}
