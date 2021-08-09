//
//  BookmarkController.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

class BookmarkController: ObservableObject {
    @Published var urls: [(uuid: String, url: URL)] = []
    
    init(preview: Bool = false) {
        if preview {
            urls = [("123", URL(string: "asdf/Test")!)]
        } else {
            getBookmarks()
        }
    }
    
    func addBookmark(for bookmarkURL: URL) {
        guard bookmarkURL.startAccessingSecurityScopedResource() else {
            // Handle the failure here.
            return
        }
            
        do {
            print("Make bookmark")
            let bookmarkData = try bookmarkURL.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            print("Bookmark made", bookmarkData)
            
            let (uuid, url) = getMyURLForBookmark()
            try bookmarkData.write(to: url)
            
            withAnimation {
                urls.append((uuid, bookmarkURL))
            }
        } catch {
            print("Error creating the bookmark")
        }
        
        bookmarkURL.stopAccessingSecurityScopedResource()
    }
    
    func removeBookmark(atOffsets offsets: IndexSet) {
        // map over offsets to get uuids
        let uuids = offsets.map { urls[$0].uuid }
        // remove from urls
        urls.remove(atOffsets: offsets)
        // delete files
        let url = getAppSandboxDirectory()
        uuids.forEach { uuid in
            try? FileManager.default.removeItem(at: url.appendingPathComponent("\(uuid)"))
        }
    }
    
    private func getAppSandboxDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getMyURLForBookmark() -> (uuid: String, url: URL) {
        var url = getAppSandboxDirectory()
        let uuid = UUID().uuidString
        url = url.appendingPathComponent("\(uuid)")
        return (uuid, url)
    }
    
    func getBookmarks() {
        let files = try? FileManager.default.contentsOfDirectory(at: getAppSandboxDirectory(), includingPropertiesForKeys: nil)
        
        self.urls = files?.compactMap({ file in
            do {
                let bookmarkData = try Data(contentsOf: file)
                var isStale = false
                let url = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
                let uuid = file.lastPathComponent
                
                guard !isStale else {
                    print("It's stale!!!")
                    return nil
                }
                
                return (uuid, url)
            }
            catch let error {
                print(error)
                return nil
            }
        }) ?? []
    }
}
