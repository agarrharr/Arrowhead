//
//  ContentView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

struct ContentView: View {
    @State var showFilePicker = false
    @State var urlSelection: URL?
    @EnvironmentObject var bookmarkController: BookmarkController

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(bookmarkController.urls, id: \.0) { uuid, url in
                        NavigationLink(url.lastPathComponent, destination: DetailView(url: url), tag: url, selection: $urlSelection)
                    }
                    .onDelete(perform: { indexSet in
                        bookmarkController.removeBookmark(atOffsets: indexSet)
                    })
                }

                Button {
                    showFilePicker = true
                } label: {
                    Label("Add Location", systemImage: "plus")
                }
                .sheet(isPresented: $showFilePicker) {
                    DocumentPicker()
                        .environmentObject(bookmarkController)
                }
            }
            .navigationTitle("Locations")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookmarkController(preview: true))
    }
}
