import SwiftUI

@main
struct ArrowheadApp: App {
    @StateObject var bookmarkController = BookmarkController()
    @StateObject var fileController = FileController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarkController)
                .environmentObject(fileController)
        }
    }
}
