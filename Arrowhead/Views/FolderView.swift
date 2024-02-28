import Dependencies
import SwiftUI

struct FolderView: View {
    @State private var showFilePicker = false
    @State private var editMode = EditMode.inactive
    
    @Dependency(\.bookmarkClient) var bookmarkClient
    
    var body: some View {
        Section(
            header: Text("Folders")
                .fontWeight(.bold)
                .textCase(.none)
                .font(.title2)
                .foregroundColor(.black)
        ) {
            ForEach(bookmarkClient.getBookmarks(), id: \.uuid) { bookmark in
                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.accentColor)
                    Text(bookmark.url.lastPathComponent)
                }
            }
            .onDelete(perform: bookmarkClient.removeBookmark)
            
            Button {
                showFilePicker = true
            } label: {
                Label("Add Folder", systemImage: "plus")
            }
            .sheet(isPresented: $showFilePicker) {
                DocumentPickerView()
            }
        }
        .headerProminence(.increased)
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FolderView()
        }
    }
}
