import Foundation

public struct Project: Equatable, Sendable, Hashable {
    public static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID
    var name: String
    var fileName: String
    var fileURL: URL
    var content: [Line]
}

// A Line is either a Note or an Action
protocol Line: Sendable {
    var id: Int { get }
}
struct LineContainer: Identifiable {
    var content: Line
    var id: Int {
        content.id
    }
}

public struct Action: Line {
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
