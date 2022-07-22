import SwiftUI

struct FolderView: View {
    @State private var showFilePicker = false
    
    @EnvironmentObject var bookmarkController: BookmarkController
    @EnvironmentObject var model: Model
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        Section(
            header: Text("Folders")
                .fontWeight(.bold)
                .textCase(.none)
                .font(.title2)
                .foregroundColor(.black)
        ) {
            ForEach(bookmarkController.bookmarks, id: \.0) { uuid, url in
                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.accentColor)
                    Text(url.lastPathComponent)
                }
            }
            .onDelete(perform: bookmarkController.removeBookmark)
            
            Button {
                showFilePicker = true
            } label: {
                Label("Add Folder", systemImage: "plus")
            }
            .sheet(isPresented: $showFilePicker) {
                DocumentPicker()
                    .environmentObject(bookmarkController)
            }
        }
        .headerProminence(.increased)
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FolderView()
                .environmentObject(BookmarkController(preview: true))
                .environmentObject(Model())
        }
    }
}
