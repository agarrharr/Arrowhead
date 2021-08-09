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
    @State var urls: [URL] = []

    var body: some Scene {
        WindowGroup {
            ContentView(urls: urls)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
