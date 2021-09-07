//
//  BookmarkController.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

class BookmarkController: ObservableObject {
    @Published var bookmarks: [(uuid: String, url: URL)] = []
    
    init(preview: Bool = false) {
        if preview {
            bookmarks = [
                ("123", URL(string: "some/path/Notes")!),
                ("124", URL(string: "some/path/Business")!),
            ]
        } else {
            getBookmarks()
        }
    }
    
    func addBookmark(for url: URL) {
        do {
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }
            
            let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            let uuid = UUID().uuidString
            let bookmarkFileURL = getAppSandboxDirectory().appendingPathComponent("\(uuid)")
            
            try bookmarkData.write(to: bookmarkFileURL)
            
            // I have to get the bookmark with this method or I won't have permission to access it
//            guard let resolvedURL = getBookmarkURL(bookmarkData: bookmarkData) else {
//                print("Error getting the newly created bookmark")
//                return
//            }
            
            withAnimation {
//                urls.append((uuid, resolvedURL))
                bookmarks.append((uuid, url))
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
    
    func getBookmarks() {
        let files = try? FileManager.default.contentsOfDirectory(at: getAppSandboxDirectory(), includingPropertiesForKeys: nil)
        
        self.bookmarks = files?.compactMap({ file in
            do {
                let bookmarkData = try Data(contentsOf: file)
                let uuid = file.lastPathComponent
                guard let url = getBookmarkURL(bookmarkData: bookmarkData) else { return nil }
                return (uuid, url)
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
