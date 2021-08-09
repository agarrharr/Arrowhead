//
//  FileController.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import Foundation

class FileController: ObservableObject {
    func getContentsOfDirectory(url: URL) -> [URL] {
        do {
            return try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
        } catch {
            print(error)
            return []
        }
    }
}
