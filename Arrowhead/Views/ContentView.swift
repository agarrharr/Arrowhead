//
//  ContentView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bookmarkController: BookmarkController
    @EnvironmentObject var model: Model
    
    var body: some View {
        NavigationView {
            FolderView()
                .navigationBarItems(leading: Image(systemName: "gear"))
                .listStyle(InsetGroupedListStyle())
        }
        .onAppear {
            // TODO: Set the active folder to the last one chosen
            model.activeFolderUUID = bookmarkController.bookmarks[0].uuid
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookmarkController(preview: true))
    }
}
