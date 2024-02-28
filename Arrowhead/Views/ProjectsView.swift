import ComposableArchitecture
import SwiftUI

struct ProjectsView: View {
    var url: URL?
    
    @Dependency(\.fileClient) var fileClient
    
    var body: some View {
        List {
            let filteredProjects = fileClient.getProjects().filter { project in
                guard let url = url else { return true }
                
                return project.fileURL.path.hasPrefix(url.path)
            }
            
            ForEach(filteredProjects, id: \.self) { project in
                NavigationLink {
                    AllTasksView(
                        url: project.fileURL
                    )
                } label: {
                    Text(project.name)
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle(url == nil ? "All Projects" : url!.deletingPathExtension().lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView {
            ProjectsView()
        }
    }
}
