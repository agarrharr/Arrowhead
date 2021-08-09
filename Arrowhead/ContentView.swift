//
//  ContentView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var showFilePicker = false
    @State var urlSelection: URL?
    @EnvironmentObject var bookmarkController: BookmarkController

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Locations")) {
                    ForEach(bookmarkController.urls, id: \.self) { url in
                        NavigationLink(url.lastPathComponent, destination: DetailView(url: url), tag: url, selection: $urlSelection)
                    }
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

struct DocumentPicker: UIViewControllerRepresentable {
    @EnvironmentObject private var bookmarkController: BookmarkController
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let documentPicker =
            UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = context.coordinator
        // documentPicker.directoryURL = startingDirectory
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
            print("Did pick url: ", url)
            parent.bookmarkController.addBookmark(url: url)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document Picker Was Cancelled")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookmarkController(preview: true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
