import SwiftUI

struct DetailView: View {
    var url: URL
    @EnvironmentObject var fileController: FileController
    
    var body: some View {
        List {
            ForEach(fileController.projects, id: \.self) { project in
                Section(header: Text(project.name)) {
                    ForEach(project.todos, id: \.id) { todo in
                        TodoView(todo: todo)
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .onAppear {
            fileController.loadProjectsFromDirectory(url: url)
        }
        .navigationTitle(url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(url: URL(string: "some/path/Notes")!)
                .environmentObject(FileController(preview: true))
        }
        .preferredColorScheme(.dark)
    }
}
