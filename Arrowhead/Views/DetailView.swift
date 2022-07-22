import SwiftUI

struct DetailView: View {
    var url: URL
    @EnvironmentObject var fileController: FileController
    
    var body: some View {
        List {
            ForEach(fileController.projects, id: \.self) { project in
                Section(header: Text(project.name)) {
                    ForEach(project.content, id: \.id) { line in
                        if line is Action {
                            TodoView(projectId: project.id, actionId: line.id)
                        } else {
                            // TODO: display notes as well
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle(url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let fileController = FileController()
        fileController.loadFakeProjects()
        
        return NavigationView {
            DetailView(url: URL(string: "some/path/Notes")!)
                .environmentObject(fileController)
        }
//        .preferredColorScheme(.dark)
    }
}
