import SwiftUI

struct AllTasksView: View {
    var url: URL?
    var fileController: FileController
    
    var body: some View {
        List {
            let filteredProjects = fileController.projects.filter { project in
                guard let url = url else { return true }
                
                return project.fileURL.path.hasPrefix(url.path)
            }
            
            ForEach(filteredProjects, id: \.self) { project in
                Section(header: Text(project.name)) {
                    ForEach(project.content, id: \.id) { line in
                        if line is Action {
                            TodoView(
                                projectId: project.id,
                                actionId: line.id,
                                fileController: fileController
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
        let fileController = FileController()
        fileController.loadFakeProjects()
        
        return NavigationView {
            AllTasksView(fileController: FileController())
        }
    }
}
