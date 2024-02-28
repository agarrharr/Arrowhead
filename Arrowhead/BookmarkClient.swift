import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct BookmarkClient {
    public var addBookmark: (_ for: URL) throws -> Void
    public var removeBookmark: (_ at: IndexSet) -> Void
    public var getBookmarks: () -> [Bookmark] = { [] }
}

extension BookmarkClient: TestDependencyKey {
  public static let testValue = Self()
}

extension DependencyValues {
  public var bookmarkClient: BookmarkClient {
    get { self[BookmarkClient.self] }
    set { self[BookmarkClient.self] = newValue }
  }
}
