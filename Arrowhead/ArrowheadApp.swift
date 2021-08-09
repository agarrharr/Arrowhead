//
//  ArrowheadApp.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

@main
struct ArrowheadApp: App {
    let bookmarkController = BookmarkController()
    let fileController = FileController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarkController)
                .environmentObject(fileController)
        }
    }
}
