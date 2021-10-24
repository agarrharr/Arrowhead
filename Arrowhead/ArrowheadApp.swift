//
//  ArrowheadApp.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

@main
struct ArrowheadApp: App {
    @StateObject var bookmarkController = BookmarkController()
    @StateObject var fileController = FileController()
    @StateObject var model = Model()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarkController)
                .environmentObject(fileController)
                .environmentObject(model)
        }
    }
}
