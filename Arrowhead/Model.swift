//
//  Model.swift
//  Arrowhead
//
//  Created by Adam Garrett-Harris on 9/7/21.
//

import Foundation

class Model: ObservableObject {
    @Published var activeFolderUUID: String
    
    init() {
        activeFolderUUID = ""
    }
}
