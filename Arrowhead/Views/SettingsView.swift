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
