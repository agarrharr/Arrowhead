//
//  ArrowheadApp.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

@main
struct ArrowheadApp: App {
    let persistenceController = PersistenceController.shared
    let bookmarkController = BookmarkController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarkController)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
