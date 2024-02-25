//
//  SMONApp.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

@main
struct SMONApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(.white)
                .environment(\.colorScheme, .dark)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// 修改NavigationBackBar的式样
extension UINavigationController {
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let backBarBtnImage = UIImage(named: "system_backbar")?
            .withRenderingMode(.alwaysTemplate).withTintColor(.white)
        UINavigationBar.appearance().backIndicatorImage = backBarBtnImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backBarBtnImage
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
