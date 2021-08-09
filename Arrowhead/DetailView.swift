//
//  DetailView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 8/9/21.
//

import SwiftUI

struct DetailView: View {
    var url: URL
    @State var urls: [URL] = []
    @EnvironmentObject var fileController: FileController
    
    var body: some View {
        List {
            ForEach(urls, id: \.self) { url in
                Text(url.lastPathComponent)
            }
        }
        .onAppear {
            urls = fileController.getContentsOfDirectory(url: url)
        }
        .navigationTitle(url.lastPathComponent)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: URL(string: "some/url")!)
    }
}
