//
//  DetailView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

struct DetailView: View {
    var url: URL
    @State private var projects: [Project] = []
    
    @EnvironmentObject var fileController: FileController
    
    var body: some View {
        List {
            ForEach(projects, id: \.self) { project in
                Section(header: Text(project.name)) {
                    ForEach(project.todos, id: \.id) { todo in
                        TodoView(todo: todo)
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .onAppear {
            projects = fileController.getTodosFromDirectory(url: url)
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
