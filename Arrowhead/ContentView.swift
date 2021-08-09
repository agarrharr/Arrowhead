//
//  ContentView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookmark.data, ascending: true)],
        animation: .default)
    private var bookmarks: FetchedResults<Bookmark>

    var body: some View {
        List {
            ForEach(bookmarks) { bookmark in
                // TODO: show the folder name here
                Text("Some bookmark")
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            EditButton()

            Button(action: addItem) {
                Label("Add Location", systemImage: "plus")
            }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
