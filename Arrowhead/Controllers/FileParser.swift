//
//  FileParser.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 3/28/22.
//

import Foundation

class FileParser {
    var lineParser = LineParser()
    
    private var isPreview: Bool
    
    init(preview: Bool = false) {
        self.isPreview = preview
    }
    
    func getAllFilesInDirectory(url: URL) -> [URL] {
        if isPreview {
            return [
                URL(string: "some/path/Home")!,
                URL(string: "some/path/Project%201")!,
                URL(string: "some/path/Project%202")!,
                URL(string: "some/path/Project%202")!,
            ]
        }
        
        var urls: [URL] = []
        
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isDirectoryKey]) {
            for case let url as URL in enumerator {
                do {
                    let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                    let isDirectory = resourceValues.isDirectory ?? false
                    if !isDirectory {
                        urls.append(url)
                    }
                } catch {
                    
                }
            }
        }
        return urls
    }
    
    public func loadProjectsFromDirectory(url: URL) -> [Project] {
        if isPreview {
            return [
                Project(
                    id: UUID(uuidString: "123")!,
                    name: "Project 1",
                    fileName: "Project 1",
                    fileURL: URL(string: "some/path/Home")!,
                    content:[
                        Action(
                            id: 1,
                            title: "Make an app",
                            completed: true,
                            tags: ["#adam"],
                            dueDate: "📅 2021-09-07") as Line
//                            subTasks: [Note(text: "What should I call it?")]) as! Line
                        ,
                        Action(
                            id: 2,
                            title: "Make it work",
                            completed: false,
                            tags: []) as Line
                    ]
                ),
                Project(
                    id: UUID(uuidString: "123")!,
                    name: "Finish livingroom",
                    fileName: "Finish livingroom",
                    fileURL: URL(string: "some/path/Home")!,
                    content: [
                        Action(
                            id: 1,
                            title: "Paint ceiling",
                            completed: false,
                            tags: []) as Line
                    ]
                )
            ]
        }
        
        var projects: [Project] = []
        
        let urls = getAllFilesInDirectory(url: url)
        
        urls.forEach { url in
            var lines: [String] = []
            if let contents = try? String(contentsOf: url) {
                lines = contents.components(separatedBy: "\n")
            }
            
            let projectID = UUID()
            
            var lineNumber = 1
            var content: [Line] = []
            lines.forEach { line in
                // TODO: Warn the user if the file contains mixed tabs and spaces
                // TODO: Ignore empty lines
                // TODO: Nest tasks and notes
                // TODO: Pull out headers and show those in the nesting
                
                if line != "" {
                    content.append(
                        lineParser.getTask(from: line, at: lineNumber)
                    )
                }
                
                lineNumber += 1
            }
            if content.count > 0 {
                projects.append(Project(id: projectID, name: url.deletingPathExtension().lastPathComponent, fileName: url.lastPathComponent, fileURL: url, content: content))
            }
        }
        
        return projects
    }

}
