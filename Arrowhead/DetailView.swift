//
//  DetailView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

struct DetailView: View {
    var url: URL
    @EnvironmentObject var bookmarkController: BookmarkController
    
    var body: some View {
        Text(url.lastPathComponent)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: URL(string: "some/url")!)
    }
}
