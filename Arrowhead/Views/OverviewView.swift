import SwiftUI

struct OverviewView: View {
    @State private var showSettings = false
    
    @EnvironmentObject var bookmarkController: BookmarkController
    
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
            OverviewView()
                .environmentObject(Model())
        }
    }
}
