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
    @State var url = URL(string: "hi")

    var body: some Scene {
        WindowGroup {
            ContentView(url: url!)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
