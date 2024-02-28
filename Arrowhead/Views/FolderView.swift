import SwiftUI

struct FolderView: View {
    @State private var showFilePicker = false
    
    private var bookmarkController = BookmarkController()
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        Section(
            header: Text("Folders")
                .fontWeight(.bold)
                .textCase(.none)
                .font(.title2)
                .foregroundColor(.black)
        ) {
            ForEach(bookmarkController.bookmarks, id: \.uuid) { bookmark in
                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.accentColor)
                    Text(bookmark.url.lastPathComponent)
                }
            }
            .onDelete(perform: bookmarkController.removeBookmark)
            
            Button {
                showFilePicker = true
            } label: {
                Label("Add Folder", systemImage: "plus")
            }
            .sheet(isPresented: $showFilePicker) {
                DocumentPickerView(bookmarkController: bookmarkController)
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
