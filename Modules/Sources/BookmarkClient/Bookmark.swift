import Foundation

public struct Bookmark: Equatable {
    public var uuid: String
    public var url: URL
    
    public init(uuid: String, url: URL) {
        self.uuid = uuid
        self.url = url
    }
}
