import Dependencies
import DependenciesMacros

@DependencyClient
public struct FileClient {
    public var loadAllProjects: () async throws -> Void
    public var getProjects: () -> [Project] = { [] }
    public var toggleTaskCompletion: (_ for: Action, _ in: Project) -> Void
}

extension FileClient: TestDependencyKey {
  public static let testValue = Self()
}

extension DependencyValues {
  public var fileClient: FileClient {
    get { self[FileClient.self] }
    set { self[FileClient.self] = newValue }
  }
}
