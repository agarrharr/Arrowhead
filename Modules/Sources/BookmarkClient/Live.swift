import Dependencies
import Foundation

func getAppSandboxDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
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

extension BookmarkClient: DependencyKey {
    public static var liveValue: Self {
        var bookmarks: [Bookmark] = []
        
        return Self(
            addBookmark: { url in
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
                
                bookmarks.append(Bookmark(uuid: uuid, url: resolvedURL))
            },
            removeBookmark: { offsets in
                let uuids = offsets.map { bookmarks[$0].uuid }
                bookmarks.remove(atOffsets: offsets)
                
                uuids.forEach { uuid in
                    try? FileManager.default.removeItem(at: getAppSandboxDirectory().appendingPathComponent("\(uuid)"))
                }
            },
            getBookmarks: {
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
        )
    }
}
