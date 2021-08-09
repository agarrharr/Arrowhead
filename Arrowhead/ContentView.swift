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
    @State var urls: [URL]
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookmark.data, ascending: true)],
        animation: .default)
    private var bookmarks: FetchedResults<Bookmark>

    var body: some View {
        VStack {
            List {
                ForEach(urls, id: \.self) { url in
                    // TODO: show the folder name here
                    Text(url.lastPathComponent)
                }
                //.onDelete(perform: deleteItems)
            }
            
            Button(action: {
                showFilePicker = true
            }) {
                Label("Add Location", systemImage: "plus")
            }
            .sheet(isPresented: $showFilePicker, content: {
                DocumentPicker(urls: $urls)
            })
        }
    }

    private func addItem() {
        withAnimation {
            let newBookmark = Bookmark(context: viewContext)
            newBookmark.data = Data()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { bookmarks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var urls: [URL]
    @Environment(\.presentationMode) var presentationMode
    
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
            print("urls count: ", parent.urls.count)
            parent.urls.append(url)
//            parent.presentationMode.wrappedValue.dismiss()
        }
        
//        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            print(urls)
//            let url = urls[0]
//            // Start accessing a security-scoped resource.
//            guard url.startAccessingSecurityScopedResource() else {
//                // Handle the failure here.
//                return
//            }
//
//            // Make sure you release the security-scoped resource when you finish.
//            defer { url.stopAccessingSecurityScopedResource() }
//
//            do {
//                // Save the URL as a bookmark
//                let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
//
////                let bookmark = Bookmark(context: managedObjectContext)
////                bookmark.data = bookmarkData
////
////                do {
////                    print("Try to save")
////                    try viewContext.save()
////                } catch {
////                    // Replace this implementation with code to handle the error appropriately.
////                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
////                    let nsError = error as NSError
////                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
////                }
//
//                // try bookmarkData.write(to: getMyURLForBookmarks())
//            } catch {
//                print("Error converting to bookmark")
//            }
//
//            // Use file coordination for reading and writing any of the URL’s content.
////            var error: NSError? = nil
////            NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
////
////                let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]
////
////                // Get an enumerator for the directory's content.
////                guard let fileList =
////                    FileManager.default.enumerator(at: url, includingPropertiesForKeys: keys) else {
////                    Swift.debugPrint("*** Unable to access the contents of \(url.path) ***\n")
////                    return
////                }
////
////                for case let file as URL in fileList {
////                    // Start accessing the content's security-scoped URL.
////                    guard url.startAccessingSecurityScopedResource() else {
////                        // Handle the failure here.
////                        continue
////                    }
////
////                    // Do something with the file here.
////                    Swift.debugPrint("chosen file: \(file.lastPathComponent)")
////
////                    // Make sure you release the security-scoped resource when you finish.
////                    url.stopAccessingSecurityScopedResource()
////                }
////            }
//
//        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Document Picker Was Cancelled")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var urls = [URL(string: "hi")!]
    static var previews: some View {
        ContentView(urls: urls).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
