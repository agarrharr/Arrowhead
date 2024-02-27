import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fileController: FileController
    
    var body: some View {
        NavigationView {
            OverviewView()
        }
        .onAppear {
            fileController.loadAllProjects()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
