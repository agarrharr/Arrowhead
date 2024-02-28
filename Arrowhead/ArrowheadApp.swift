import ComposableArchitecture
import SwiftUI

@main
struct ArrowheadApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: AppReducer.State()) {
                AppReducer()
            })
        }
    }
}
