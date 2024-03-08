//
//  XMCom.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/8.
//

import Foundation


struct XMCompetition: Identifiable,Equatable{
    var id = UUID().uuidString
    var movieTitle: String = "包臀裙大赛"
    var artwork: String
    var date : Date = .init()
}
