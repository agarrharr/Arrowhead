//
//  FileController.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import Foundation

class FileController: ObservableObject {
    private var isPreview: Bool
    
    init(preview: Bool = false) {
        self.isPreview = preview
    }
    
    func getContentsOfDirectory(url: URL) -> [URL] {
        if isPreview {
            return [
                URL(string: "some/path/Home")!,
                URL(string: "some/path/Project%201")!,
                URL(string: "some/path/Project%202")!,
                URL(string: "some/path/Project%202")!,
            ]
        }
        do {
            return try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch {
            print(error)
            return []
        }
    }
}
