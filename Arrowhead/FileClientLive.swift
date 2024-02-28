import Dependencies
import Foundation

extension FileClient: DependencyKey {
    public static var liveValue: Self {
        var projects: [Project] = []
        var fileParser = FileParser()

        func loadProjectsFromDirectory(url: URL) -> [Project] {
            fileParser.loadProjectsFromDirectory(url: url)
        }
        
        return Self(
            loadAllProjects: {
                @Dependency(\.bookmarkClient) var bookmarkClient
                
                // Get bookmarks with Combine
                bookmarkClient.getBookmarks().forEach { bookmark in
                    projects.append(contentsOf: loadProjectsFromDirectory(url: bookmark.url))
                }
                print(projects)
            },
            getProjects: { projects },
            toggleTaskCompletion: { todo, project in
                var lines: [String] = []
                
                if let contents = try? String(contentsOf: project.fileURL) {
                    lines = contents.components(separatedBy: "\n")
                }
                
                var line = lines[todo.id - 1]
                
                if (todo.completed) {
                    let regex = try! NSRegularExpression(pattern: #"(^\s*[-*]{1} \[[xX]{1}\] )"#)
                    line = regex.stringByReplacingMatches(in: line, options: [], range: NSRange(0..<line.utf16.count), withTemplate: "- [ ] ")
                } else {
                    let regex = try! NSRegularExpression(pattern: #"(^\s*[-*]{1} \[ \] )"#)
                    line = regex.stringByReplacingMatches(in: line, options: [], range: NSRange(0..<line.utf16.count), withTemplate: "- [x] ")
                }
                
                lines[todo.id - 1] = line
                try? lines.joined(separator: "\n").write(to: project.fileURL, atomically: true, encoding: .utf8)
                
                let projectIndex = projects.firstIndex(where: { $0.id == project.id })
                let taskIndex = projects[projectIndex ?? -1].content.firstIndex(where: { $0.id == todo.id })
                
                let action = projects[projectIndex ?? -1].content[taskIndex ?? -1]
                if var action  = action as? Action {
                    action.completed.toggle()
                    projects[projectIndex ?? -1].content[taskIndex ?? -1] = action
                }
            }
        )
    }
}
