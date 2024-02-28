import FileClient
import Dependencies
import SwiftUI

struct TodoView: View {
    @State var projectId: UUID
    @State var actionId: Int
    
    @Dependency(\.fileClient) var fileClient
    
    var body: some View {
        let project = fileClient.getProjects().filter { project in
                project.id == projectId
        }.first

        guard let project = project else { return AnyView(EmptyView()) }

        let todo = project.content.filter { line in
            line.id == actionId
        }.first

        guard let todo = todo as? Action else { return AnyView(EmptyView()) }
        
        return AnyView(VStack {
            HStack {
                Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        fileClient.toggleTaskCompletion(for: todo, in: project)
                    }
                Text(todo.title)
                Spacer()
            }
            HStack {
                ForEach(todo.tags, id: \.self) { tag in
                    Text(tag)
                        .foregroundColor(Color("OppositeTextColor"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .background(Color("LightGray"))
                        .cornerRadius(10.0)
                }
                Spacer()
            }
            if todo.dueDate != nil {
                HStack {
                    Text(todo.dueDate!)
                            
                    Spacer()
                }
            }
            if todo.doneDate != nil {
                HStack {
                    Text(todo.doneDate!)
                            
                    Spacer()
                }
            }
        })
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: give correct uuid and action id
        return TodoView(projectId: UUID(), actionId: 1)
            .preferredColorScheme(.dark)
    }
}
