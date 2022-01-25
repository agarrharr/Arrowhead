import Foundation

class Model: ObservableObject {
    @Published var activeFolderUUID: String
    
    init() {
        activeFolderUUID = ""
    }
}
