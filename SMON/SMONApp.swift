//
//  SMONApp.swift
//  SMON
//
//  Created by 赵翔宇 on 2024/2/22.
//

import SwiftUI

@main
struct SMONApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
