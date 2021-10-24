//
//  OverviewView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 9/8/21.
//

import SwiftUI

struct OverviewView: View {
    @EnvironmentObject var bookmarkController: BookmarkController
    @EnvironmentObject var model: Model
    
    var body: some View {
        List {
            PerspectivesView()
            FolderView()
        }
        .navigationBarItems(leading: Image(systemName: "gear"))
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OverviewView()
                .environmentObject(BookmarkController(preview: true))
                .environmentObject(Model())
        }
    }
}
