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
                    todos:[
                        Todo(
                            id: UUID(),
                            projectID: UUID(uuidString: "123")!,
                            fileURL: URL(string: "some/path/Home")!,
                            fileName: "Project 1",
                            lineNumber: 1,
                            completed: true,
                            title: "Make an app",
                            tags: ["#adam"],
                            dueDate: "📅 2021-09-07",
                            subTasks: [Note(text: "What should I call it?")])
                        ,
                        Todo(
                            id: UUID(),
                            projectID: UUID(uuidString: "123")!,
                            fileURL: URL(string: "some/path/Home")!,
                            fileName: "Project 1",
                            lineNumber: 1,
                            completed: false,
                            title: "Make it work",
                            tags: [])
                    ]
                ),
                Project(
                    id: UUID(uuidString: "123")!,
                    name: "Finish livingroom",
                    todos: [
                        Todo(
                            id: UUID(),
                            projectID: UUID(uuidString: "123")!,
                            fileURL: URL(string: "some/path/Home")!,
                            fileName: "Finish livingroom",
                            lineNumber: 1,
                            completed: false,
                            title: "Paint ceiling",
                            tags: [])
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
            var todos: [Todo] = []
            lines.forEach { line in
                // TODO: Warn the user if the file contains mixed tabs and spaces
                // TODO: Ignore empty lines
                // TODO: Nest tasks and notes
                // TODO: Pull out headers and show those in the nesting
                
                if line != "" {
                    if let task = lineParser.getTask(string: line) {
                        todos.append(
                            Todo(id: UUID(), projectID: projectID, fileURL: url, fileName: url.lastPathComponent, lineNumber: lineNumber, completed: task.isCompleted, title: task.title, tags: task.tags, dueDate: task.dueDate, doneDate: task.doneDate)

                        )
                    }
                }
                
                lineNumber += 1
            }
            if todos.count > 0 {
                projects.append(Project(id: projectID, name: url.lastPathComponent, todos: todos))
            }
        }
        
        return projects
    }

}
