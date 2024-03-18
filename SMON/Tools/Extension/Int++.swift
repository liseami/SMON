//
//  Int.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/3/18.
//

import Foundation

extension Int {
    var daysUntilDeadline: Int {
        let currentTime = Int(Date().timeIntervalSince1970)
        let timeDifference = self - currentTime
        let secondsInDay = 86400 // 24 hours * 60 minutes * 60 seconds
        let days = timeDifference / secondsInDay
        return days
    }

  mutating  func toggle() {
        self == 1 ? { self = 2 }() : { self = 1 }()
    }

    var bool: Bool {
        self == 1
    }
}
