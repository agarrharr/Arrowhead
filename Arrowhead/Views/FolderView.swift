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
        Section(
            header: Text("Folders")
                .fontWeight(.bold)
                .textCase(.none)
                .font(.title2)
                .foregroundColor(.black)
        ) {
            ForEach(bookmarkController.bookmarks, id: \.0) { uuid, url in
                NavigationLink(
                    destination: DetailView(url: url),
                    isActive: isEqual(self.$model.activeFolderUUID, uuid, inequalValue: ""),
                    label: {
                        Label {
                            Text(url.lastPathComponent)
                        } icon: {
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)
                        }
                    })
            }
            .onDelete(perform: bookmarkController.removeBookmark)
            
            Button {
                print("tap")
                showFilePicker = true
            } label: {
                Label("Add Folder", systemImage: "plus")
            }
            .sheet(isPresented: $showFilePicker) {
                DocumentPicker()
                    .environmentObject(bookmarkController)
            }
        }
        //.headerProminence(.increased) // TODO: iOS 15 only
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
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
