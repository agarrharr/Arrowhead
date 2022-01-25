//
//  TodoView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 9/7/21.
//

import SwiftUI

struct TodoView: View {
    @State var todo: Todo
    
    @EnvironmentObject var fileController: FileController
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        fileController.toggleTaskCompletion(todo: todo)
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
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        let todo1 = Todo(id: UUID(), fileURL: URL(string: "path/to/file")!, fileName: "Project 1", lineNumber: 1, completed: false, title: "Take out the trash", tags: ["#adam", "#next"], dueDate: "📅 2021-09-07", doneDate: nil, subTasks: nil)
        
        TodoView(todo: todo1)
            .environmentObject(FileController(preview: true))
            .preferredColorScheme(.dark)
    }
}
