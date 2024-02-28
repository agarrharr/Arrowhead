import ComposableArchitecture
import SwiftUI

struct AllTasksView: View {
    var url: URL?
    
    @Dependency(\.fileClient) var fileClient
    
    var body: some View {
        List {
            let filteredProjects = fileClient.getProjects().filter { project in
                guard let url = url else { return true }
                
                return project.fileURL.path.hasPrefix(url.path)
            }
            
            ForEach(filteredProjects, id: \.self) { project in
                Section(header: Text(project.name)) {
                    ForEach(project.content, id: \.id) { line in
                        if line is Action {
                            TodoView(
                                projectId: project.id,
                                actionId: line.id
                            )
                        } else {
                            // TODO: display notes as well
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle(url == nil ? "All Tasks" : url!.deletingPathExtension().lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AllTasksView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView {
            AllTasksView()
        }
    }
}
