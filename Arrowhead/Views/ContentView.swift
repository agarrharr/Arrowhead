import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bookmarkController: BookmarkController
    @EnvironmentObject var model: Model
    
    var body: some View {
        NavigationView {
            OverviewView()
        }
        .onAppear {
            // if bookmarkController.bookmarks.count > 0 {
            //     model.activeFolderUUID = bookmarkController.bookmarks[0].uuid
            // }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookmarkController(preview: true))
            .environmentObject(Model())
    }
}
