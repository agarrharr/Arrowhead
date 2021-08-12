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
    
    func addBookmark(for url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            // Handle the failure here.
            return
        }
        
        do {
            let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
            
            let (uuid, bookmarkFileURL) = getUUIDAndFileURLForBookmark()
            try bookmarkData.write(to: bookmarkFileURL)
            
            // I have to get the bookmark with this method or I won't have permission to access it
            guard let resolvedURL = getBookmarkURL(bookmarkData: bookmarkData) else {
                print("Error getting the newly created bookmark")
                return
            }
            
            withAnimation {
                urls.append((uuid, resolvedURL))
            }
            
        } catch {
            print("Error creating the bookmark")
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    func removeBookmark(atOffsets offsets: IndexSet) {
        let uuids = offsets.map { urls[$0].uuid }
        urls.remove(atOffsets: offsets)
        
        uuids.forEach { uuid in
            try? FileManager.default.removeItem(at: getAppSandboxDirectory().appendingPathComponent("\(uuid)"))
        }
    }
    
    private func getAppSandboxDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getUUIDAndFileURLForBookmark() -> (uuid: String, url: URL) {
        let sandboxDirectory = getAppSandboxDirectory()
        let uuid = UUID().uuidString
        let bookmarkFileURL = sandboxDirectory.appendingPathComponent("\(uuid)")
        return (uuid, bookmarkFileURL)
    }
    
    func getBookmarks() {
        let files = try? FileManager.default.contentsOfDirectory(at: getAppSandboxDirectory(), includingPropertiesForKeys: nil)
        
        self.urls = files?.compactMap({ file in
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
