import ComposableArchitecture
import SwiftUI

@Reducer
struct OverviewReducer {
    @ObservableState
    struct State: Equatable {
        var bookmarks: [Bookmark] = []
    }
}

struct OverviewView: View {
    let store: StoreOf<OverviewReducer>
    var bookmarkController: BookmarkController
    var fileController = FileController()
    
    @State private var showSettings = false
    
    var body: some View {
        List {
            NavigationLink {
                ProjectsView()
            } label: {
                Text("All Tasks")
            }
            ForEach(bookmarkController.bookmarks, id: \.uuid) { bookmark in
                NavigationLink {
                    ProjectsView(url: bookmark.url)
                } label: {
                    Text(bookmark.url.deletingPathExtension().lastPathComponent)
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "gear")
                    .onTapGesture {
                      showSettings = true
                    }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OverviewView(
                store: Store(
                    initialState: OverviewReducer.State(
                        bookmarks: [
                            Bookmark(uuid: "123", url: URL(string: "http://www.url.com")!)
                        ]
                    )
                ) {
                    OverviewReducer()
                },
                bookmarkController: BookmarkController()
            )
        }
    }
}
