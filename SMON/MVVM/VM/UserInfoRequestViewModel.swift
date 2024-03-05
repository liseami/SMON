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
    @Published var morePhoto: [UIImage] = []
    @Published var brithday: Date = Calendar.current.date(from: DateComponents.init(year: 2000, month: 1, day: 1)) ?? .now
    @Published var sex: Int = 0
    @Published var emotionalNeeds: Int = 0
    @Published var height : Int = 160
    @Published var bdsmAttr : Int = 0
    @Published var wechat : String  = ""
    @Published var interestsTag : [String] = []
    
    @Published var bio : String  = ""
    @Published var showCompleteView: Bool = false
    @Published var presentedSteps: [PageStep] = [.name]
    enum PageStep: CaseIterable {
        case name
        case photo
        case morephoto
        case brithday
        case sex
        case relationhope
        case bdsm
        case hobby
        case height
//        case drink
//        case smoke
        case wechat
        case bio
    }
}
