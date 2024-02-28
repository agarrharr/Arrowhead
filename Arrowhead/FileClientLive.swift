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
                let bookmarkController = BookmarkController()
                
                // Get bookmarks with Combine
                bookmarkController.bookmarks.forEach { bookmark in
                    projects.append(contentsOf: loadProjectsFromDirectory(url: bookmark.url))
                }
                print(projects)
            },
            getProjects: { projects }
        )
    }
}
