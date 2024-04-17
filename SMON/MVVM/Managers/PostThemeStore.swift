//
//  PostThemeStore.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/4/17.
//

import Foundation

class PostThemeStore: ObservableObject {
    static let shared: PostThemeStore = .init()

    @Published var themeList: [XMTheme] = []
    @Published var targetTheme: XMTheme?
    
    func reset() {
        self.themeList = []
        self.targetTheme = nil
    }
}
