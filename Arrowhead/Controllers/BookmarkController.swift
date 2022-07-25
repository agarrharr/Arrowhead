import SwiftUI

struct Bookmark {
    var uuid: String
    var url: URL
}

class BookmarkController: ObservableObject {
    @Published var bookmarks: [Bookmark] = []
    
    init(preview: Bool = false) {
        if preview {
            bookmarks = [
                Bookmark(uuid: "123", url: URL(string: "some/path/Notes")!),
                Bookmark(uuid: "124", url: URL(string: "some/path/Business")!),
            ]
        } else {
            bookmarks = getBookmarks()
        }
    }
    
    func addBookmark(for url: URL) {
        do {
            guard url.startAccessingSecurityScopedResource() else {
                // TODO: Handle the failure here.
                return
            }
            
            let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            let uuid = UUID().uuidString
            let bookmarkFileURL = getAppSandboxDirectory().appendingPathComponent("\(uuid)")
            
            try bookmarkData.write(to: bookmarkFileURL)
            
            // Get the bookmark with this method or I won't have permission to access it
            guard let resolvedURL = getBookmarkURL(bookmarkData: bookmarkData) else {
                print("Error getting the newly created bookmark")
                return
            }
            
            withAnimation {
                bookmarks.append(Bookmark(uuid: uuid, url: resolvedURL))
            }
            
        } catch {
            print("Error creating the bookmark")
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    func removeBookmark(at offsets: IndexSet) {
        let uuids = offsets.map { bookmarks[$0].uuid }
        bookmarks.remove(atOffsets: offsets)
        
        uuids.forEach { uuid in
            try? FileManager.default.removeItem(at: getAppSandboxDirectory().appendingPathComponent("\(uuid)"))
        }
    }
    
    private func getAppSandboxDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getBookmarks() -> [Bookmark] {
        let files = try? FileManager.default.contentsOfDirectory(at: getAppSandboxDirectory(), includingPropertiesForKeys: nil)
        
        return files?.compactMap({ file in
            do {
                let bookmarkData = try Data(contentsOf: file)
                let uuid = file.lastPathComponent
                guard let url = getBookmarkURL(bookmarkData: bookmarkData) else { return nil }
                return Bookmark(uuid: uuid, url: url)
            }
            catch let error {
                print(error)
                return nil
            }
        }) ?? []
    }
    
    func getBookmarkURL(bookmarkData: Data) -> URL? {
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
            
            guard !isStale else {
                print("Bookmark is stale")
                return nil
            }
            
            return url
        }
        catch let error {
            print(error)
            return nil
        }
    }
}
