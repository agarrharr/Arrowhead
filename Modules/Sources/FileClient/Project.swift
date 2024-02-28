import Foundation

public struct Project: Equatable, Sendable, Hashable {
    public static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var id: UUID
    public var name: String
    public var fileName: String
    public var fileURL: URL
    public var content: [Line]
}

// A Line is either a Note or an Action
public protocol Line: Sendable {
    var id: Int { get }
}

public struct Action: Line {
    public var id: Int
    public var title: String
    public var completed: Bool
    public var tags: [String]
    public var dueDate: String?
    public var doneDate: String?
    // TODO: add indentation level
}

// A Note can be any characters that aren't a task, including an empty line, or a heading, and with any indentation
struct Note: Line {
    var id: Int
    var text: String
    // TODO: add heading level
    // TODO: add indentation level
}

