//
//  FileController.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import Foundation

struct Project: Hashable {
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.name == rhs.name
    }
    
    var name: String
    var todos: [Todo]
}

struct Todo: Hashable {
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var fileURL: URL
    var fileName: String
    var lineNumber: Int
    var completed: Bool
    var title: String
    var tags: [String]
    var dueDate: String?
    var doneDate: String?
    var subTasks: [Note]?
}

struct Note: Hashable {
    var text: String?
    var todo: Todo?
}

class FileController: ObservableObject {
    private var isPreview: Bool
    
    init(preview: Bool = false) {
        self.isPreview = preview
    }
    
    func getTodosFromDirectory(url: URL) -> [Project] {
        if isPreview {
            return [
                Project(
                    name: "Project 1",
                    todos:[
                        Todo(
                            id: UUID(),
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
                            fileURL: URL(string: "some/path/Home")!,
                            fileName: "Project 1",
                            lineNumber: 1,
                            completed: false,
                            title: "Make it work",
                            tags: [])
                    ]
                ),
                Project(
                    name: "Finish livingroom",
                    todos: [
                        Todo(
                            id: UUID(),
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
            
            var lineNumber = 1
            var todos: [Todo] = []
            lines.forEach { line in
                // TODO: Warn the user if the file contains mixed tabs and spaces
                // TODO: extract hashtags
                // TODO: extract dates
                // TODO: Ignore empty lines
                // TODO: nest tasks and notes
                // TODO: Pull out headers and use those
                // Question: Should files within user-defined projects folders show up even if there are no tasks?
                
                if line != "" {
                    if let task = getTask(string: line) {
                        todos.append(
                            Todo(id: UUID(), fileURL: url, fileName: url.lastPathComponent, lineNumber: lineNumber, completed: task.isCompleted, title: task.title, tags: task.tags, dueDate: task.dueDate, doneDate: task.doneDate)

                        )
                    }
                }
                
                lineNumber += 1
            }
            if todos.count > 0 {
                projects.append(Project(name: url.lastPathComponent, todos: todos))
            }
        }
        
        return projects
    }
    
    func getTask(string: String) -> (title: String, isCompleted: Bool, tags: [String], dueDate: String?, doneDate: String?)? {
        let regex = try! NSRegularExpression(pattern: #"(^\s*[-*]{1} \[([ xX]{1})\] )"#)
        let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))

        if matches.count > 0 {
            let range = matches[0].range(at: 1)
            
            let fullTitle = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
            let (titleWithoutTags, tags) = findHashtags(string: fullTitle)
            let (titleWitoutDueDate, dueDate) = findDueDate(string: titleWithoutTags)
            let (title, doneDate) = findDoneDate(string: titleWitoutDueDate)
            
            let checkmarkIndex = matches[0]
                .range(at: 2) // get the second matching group
                .lowerBound
            let checkmark = string[string.index(string.startIndex, offsetBy: checkmarkIndex)].lowercased()
            let isCompleted = checkmark == "x"
            
            return (title, isCompleted, tags, dueDate, doneDate)
        }
        return nil
    }
    
    func getIndentationLevel(string: String) -> Int {
        let regex = try! NSRegularExpression(pattern: "^(\\s+)")
        let matches = regex.matches(in: string, range: NSRange(location: 0, length: string.utf16.count))

        if matches.count > 0 {
            let nsRange = matches[0].range(at: 1)
            let range = Range(nsRange, in: string)!
            return string[range].count
        }
        return 0
    }
    
    func findHashtags(string: String) -> (newString: String, tags: [String]) {
        var hashtags:[String] = []
        var newString: String = string
        var numberOfRemovedCharacters = 0
        let regex = try? NSRegularExpression(pattern: " (#[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)", options: [])
        if let matches = regex?.matches(in: string, options:[], range:NSMakeRange(0, string.utf16.count)) {
            for match in matches {
                hashtags.append(NSString(string: string).substring(with: NSRange(location: match.range.location, length: match.range.length)))
                newString = regex?.stringByReplacingMatches(in: newString, options: [], range: NSRange(location: match.range.location - numberOfRemovedCharacters, length: match.range.length), withTemplate: "") ?? newString
                numberOfRemovedCharacters += match.range.length
            }
        }
        
        return (newString: newString, tags: hashtags)
    }
    
    func findDueDate(string: String) -> (newString: String, date: String?) {
        findDate(string, withEmoji: "📅")
    }
    
    func findDoneDate(string: String) -> (newString: String, date: String?) {
        findDate(string, withEmoji: "✅")
    }
    
    func findDate(_ string: String, withEmoji emoji: String) -> (newString: String, date: String?) {
        var dates:[String] = []
        var newString: String = string
        var numberOfRemovedCharacters = 0
        let regex = try? NSRegularExpression(pattern: " (\(emoji) [0-9]{4}-[0-9]{2}-[0-9]{2})", options: [])
        if let matches = regex?.matches(in: string, options:[], range:NSMakeRange(0, string.utf16.count)) {
            for match in matches {
                dates.append(NSString(string: string).substring(with: NSRange(location: match.range.location, length: match.range.length)))
                newString = regex?.stringByReplacingMatches(in: newString, options: [], range: NSRange(location: match.range.location - numberOfRemovedCharacters, length: match.range.length), withTemplate: "") ?? newString
                numberOfRemovedCharacters += match.range.length
            }
        }
        
        return (newString: newString, date: dates.count > 0 ? dates[0] : nil)
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
}
