//
//  UserController.swift
//  Writing
//
//  Created by Ben Dreyer on 6/18/24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation

class UserController : ObservableObject {
    // Firestore
    let db = Firestore.firestore()
    
    // Storage
    let storage = Storage.storage()
    
    // User object - used to reference user throughout the app (signed in only)
    @Published var user: User?
    // Users profile picture
    @Published var usersProfilePicture: UIImage?
    
    init() {
        // Retrieve the user on init if auth'd
        if let userId = Auth.auth().currentUser?.uid {
            self.retrieveUserFromFirestore(userId: userId)
            self.retrieveUsersProfilePicture(userId: userId)
        } else {
            print("auth wasn't setup yet.")
        }
    }
    
    func retrieveUserFromFirestore(userId: String) {
        let docRef = db.collection("users").document(userId)
        docRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let userObject):
                self.user = userObject
                print("we have the user: ", self.user?.email ?? "no email")
            case .failure(let error):
                print("Failure retrieving user from firestore: ", error.localizedDescription)
            }
        }
    }
    
    func retrieveUsersProfilePicture(userId: String) {
        let imageRef = self.storage.reference().child("profile_pictures/" + userId + ".jpeg")
        
        Task {
            // download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error downloading user's profile picture from storage: ", error.localizedDescription)
                    // There was an issue with the image or the image doesn't exist, either way set both prompt and promptImage back to nil
                    return
                } else {
                    DispatchQueue.main.async {
                        // Data for image is returned
                        let image = UIImage(data: data!)
                        self.usersProfilePicture = image
                    }
                }
            }
            
        }
    }
    
    func logOut() {
        self.user = nil
        self.usersProfilePicture = nil
    }
}
