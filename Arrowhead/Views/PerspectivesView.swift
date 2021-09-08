//
//  PerspectivesView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 9/8/21.
//

import SwiftUI

let columns: [GridItem] = [GridItem(), GridItem()]

struct PerspectivesView: View {
    var body: some View {
        Section(header: VStack {
            LazyVGrid(columns: columns, spacing: 15) {
                PerspectiveTileView(name: "Today", color: Color(UIColor.systemIndigo), image: "house.circle.fill", number: 2)
                PerspectiveTileView(name: "Scheduled", color: Color(.red), image: "calendar.circle.fill", number: 7)
                PerspectiveTileView(name: "All", color: Color(.gray), image: "tray.circle.fill", number: 22)
                PerspectiveTileView(name: "Flagged", color: Color(.orange), image: "flag.circle.fill", number: 1)
            }
        }
        .padding(.top)
        .textCase(.none)
        ) {
            
        }
    }
}

struct PerspectivesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                PerspectivesView()
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
