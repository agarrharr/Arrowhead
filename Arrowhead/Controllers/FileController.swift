import Foundation

struct Project: Hashable {
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.name == rhs.name
    }
    
    var id: UUID
    var name: String
    var todos: [Todo]
}

struct Todo: Hashable {
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: UUID
    var projectID: UUID
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
    @Published var projects: [Project] = []
    var fileParser = FileParser()
    
    public func loadProjectsFromDirectory(url: URL) {
        projects = fileParser.loadProjectsFromDirectory(url: url)
    }
    
    public func toggleTaskCompletion(todo: Todo) {
        var lines: [String] = []
        
        if let contents = try? String(contentsOf: todo.fileURL) {
            lines = contents.components(separatedBy: "\n")
        }
        
        var line = lines[todo.lineNumber - 1]
        
        if (todo.completed) {
            let regex = try! NSRegularExpression(pattern: #"(^\s*[-*]{1} \[[xX]{1}\] )"#)
            line = regex.stringByReplacingMatches(in: line, options: [], range: NSRange(0..<line.utf16.count), withTemplate: "- [ ] ")
        } else {
            let regex = try! NSRegularExpression(pattern: #"(^\s*[-*]{1} \[ \] )"#)
            line = regex.stringByReplacingMatches(in: line, options: [], range: NSRange(0..<line.utf16.count), withTemplate: "- [x] ")
        }

        lines[todo.lineNumber - 1] = line
        try? lines.joined(separator: "\n").write(to: todo.fileURL, atomically: true, encoding: .utf8)
        
        let projectIndex = self.projects.firstIndex(where: { $0.id == todo.projectID })
        let taskIndex = self.projects[projectIndex ?? -1].todos.firstIndex(where: { $0.id == todo.id })
        self.projects[projectIndex ?? -1].todos[taskIndex ?? -1].completed.toggle()
    }
}
