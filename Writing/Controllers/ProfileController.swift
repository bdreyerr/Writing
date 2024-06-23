//
//  ProfileController.swift
//  Writing
//
//  Created by Ben Dreyer on 6/15/24.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import SwiftUI

class ProfileController : ObservableObject {
    
    @Published var shorts: [Short] = []
    @Published var promptImages: [UIImage] = []
    
    // vars that control the view
    
    @Published var isSettingsShowing: Bool = false
    @Published var showSidebar: Bool = false
    
    // Firebase
    
    
    // Retrieves shorts the user has written, to be displayed on their profile
    // TODO: implemnet infinite scroll / pagination
    func retrieveShorts(userId: String) {
        
    }
}
