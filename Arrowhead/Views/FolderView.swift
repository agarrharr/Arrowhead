//
//  FolderView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 9/7/21.
//

import SwiftUI

struct FolderView: View {
    @State private var showFilePicker = false
    
    @EnvironmentObject var bookmarkController: BookmarkController
    @EnvironmentObject var model: Model
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        List {
            ForEach(bookmarkController.bookmarks, id: \.0) { uuid, url in
                NavigationLink(
                    destination: DetailView(url: url),
                    isActive: isEqual(self.$model.activeFolderUUID, uuid, inequalValue: ""),
                    label: {
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)
                            Text(url.lastPathComponent)
                        }
                    })
            }
            .onDelete(perform: bookmarkController.removeBookmark)

            if editMode == EditMode.active || bookmarkController.bookmarks.count == 0 {
                Button {
                    showFilePicker = true
                } label: {
                    Label("Add Folder", systemImage: "plus")
                }
                .sheet(isPresented: $showFilePicker) {
                    DocumentPicker()
                        .environmentObject(bookmarkController)
                }
            }
        }
        .navigationTitle("Folders")
        .navigationBarItems(trailing: EditButton())
        .environment(\.editMode, $editMode)
        .listStyle(GroupedListStyle())
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FolderView()
                .environmentObject(BookmarkController(preview: true))
                .environmentObject(Model())
        }
    }
}

// Returns a Binding that is true if the value of `binding` equals `value`.
// If the value of the resulting binding is set, the original binding is set to value/inEqualValue.
public func isEqual<T: Equatable>(_ binding: Binding<T>, _ value: T, inequalValue: T) -> Binding<Bool> {
    Binding(
        get: { binding.wrappedValue == value },
        set: { newValue in binding.wrappedValue = newValue ? value : inequalValue }
    )
}
