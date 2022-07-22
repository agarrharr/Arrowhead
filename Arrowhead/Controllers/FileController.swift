import Foundation

struct Project: Hashable {
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID
    var name: String
    var fileName: String
    var fileURL: URL
    var content: [Line]
}

// A Line is either a Note or an Action
protocol Line {
    var id: Int { get }
}
struct LineContainer: Identifiable {
    var content: Line
    var id: Int {
        content.id
    }
}

struct Action: Line {
    var id: Int
    var title: String
    var completed: Bool
    var tags: [String]
    var dueDate: String?
    var doneDate: String?
    // TODO: add indentation level
}

// A Note can be any characters that aren't a task, including an empty line, or a heading, and with any indentation
struct Note: Line {
    var id: Int
    var text: String
    // TODO: add heading level
    // TODO: add indentation level
}

class FileController: ObservableObject {
    @Published var projects: [Project] = []
    var fileParser = FileParser()
    
    public func loadProjectsFromDirectory(url: URL) {
        projects = fileParser.loadProjectsFromDirectory(url: url)
    }
    
    public func loadFakeProjects() {
        projects = [
            Project(id: UUID(), name: "Project 1", fileName: "Project1.md", fileURL: URL(string: "some/path/to/notes")!, content: [
//                Note(id: 1),
                Action(id: 2, title: "Do the thing", completed: false, tags: []),
                Action(
                    id: 3,
                    title: "Take out the trash",
                    completed: false,
                    tags: ["#adam", "#next"],
                    dueDate: "📅 2021-09-07",
                    doneDate: nil
                )
            ])
        ]
    }
    
    public func toggleTaskCompletion(for todo: Action, in project: Project) {
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

        let projectIndex = self.projects.firstIndex(where: { $0.id == project.id })
        let taskIndex = self.projects[projectIndex ?? -1].content.firstIndex(where: { $0.id == todo.id })
        
        let action = self.projects[projectIndex ?? -1].content[taskIndex ?? -1]
        if var action  = action as? Action {
            action.completed.toggle()
            self.projects[projectIndex ?? -1].content[taskIndex ?? -1] = action
        }
    }
}
