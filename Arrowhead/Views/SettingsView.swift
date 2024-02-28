//
//  SettingsView.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 7/22/22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                FolderView()
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
