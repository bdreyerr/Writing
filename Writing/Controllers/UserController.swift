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
    
    
    // Rate Limiting
    @Published var numActionsInLastMinute: Int = 0
    @Published var firstActionDate: Date?
    
    // User object - used to reference user throughout the app (signed in only)
    @Published var user: User?
    // Users profile picture
    @Published var usersProfilePicture: UIImage?
    
    // Edit profile vars
    @Published var newFirstName: String = ""
    @Published var newLastName: String = ""
    
    // Firestore
    let db = Firestore.firestore()
    
    // Storage
    let storage = Storage.storage()
    
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
        self.user = nil
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
        print("log out - local user")
    }
    
    func deleteUser() {
        // Delete the current user in firestore (not auth)
        Task {
            if let user = self.user {
                do {
                    try await db.collection("users").document(user.id!).delete()
                    print("Document successfully removed!")
                    DispatchQueue.main.async {
                        self.logOut()
                    }
                    
                } catch {
                    print("Error removing document: \(error)")
                }
            } else {
                print("no user and we can't delete it")
            }
        }
    }
    
    func changeName() {
        print("starting name change")
        // Rate limit
        
        if self.newFirstName != "" && self.newLastName != "" {
            // ensure current user
            if let user = self.user {
                if self.newFirstName != user.firstName! && self.newLastName != user.lastName! {
                    // Reach out to fire base to update the names
                    Task {
                        let docRef = self.db.collection("users").document(user.id!)
                        
                        do {
                            try await docRef.updateData([
                                "firstName": self.newFirstName,
                                "lastName": self.newLastName
                            ])
                            print("updated successfully")
                        } catch let error {
                            print("error updating name: ", error.localizedDescription)
                        }
                        
                        // refresh the local user object
                        self.retrieveUserFromFirestore(userId: user.id!)
                        
                        // Change the name on every short authored by the current user!
                    }
                } else {
                    print("names are the same")
                }
            } else {
                print("no user")
            }
        } else {
            print("empty first name or last name")
        }
    }
    
    func uploadProfilePicture(data: Data) {
        // TODO: see if we can scale down the image to a certain res?
        if let user = self.user {
            let imageRef = storage.reference().child("profile_pictures/" + user.id! + ".jpeg")
            
            // Add metadate for the image
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            print("the size of the data in bytes is: ", data.count)
            // compress image
            if let newData = compressImageData(imageData: data, maxSizeInBytes: (1 * 1024 * 1024)) {
                print("after compression function the size in bytes is: ", newData.count)
                
                
                imageRef.putData(newData, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("error uploading photo to storage: ", error.localizedDescription)
                        return
                    }
                    guard let _ = metadata else { return }
                    
                    // refresh the profile picture
                    self.retrieveUsersProfilePicture(userId: user.id!)
                }
            } else {
                print("new data was nuil")
            }
        }
    }
    
    func compressImageData(imageData: Data, maxSizeInBytes: Int) -> Data? {
        
        print("image data size: ", imageData.count)
        var compressionScaler = 1.0
        switch imageData.count {
        case 0..<500_000:
            print("under 500 KB")
            compressionScaler = 1.0
        case 500_000..<1_000_000:
            print("between 500KB and 1MB")
            compressionScaler = 0.9
        case 1_000_000..<5_000_000:
            print("between 1MB and 5MB")
            compressionScaler = 0.15
        case 5_000_000..<10_000_000:
            print("between 5MB and 10MB")
            compressionScaler = 0.05
        default:
            print("larger than 10MB")
            return nil
        }
        
        guard let image = UIImage(data: imageData) else { return nil }
        let newImageData = image.jpegData(compressionQuality: compressionScaler)
        
        print("after compression, size is: ", newImageData!.count)
        return newImageData
    }
    
    func blockUser(userId: String) {
        // blocks the userId passed in from the arguments (if the user is not already blocked)
        
        if let user = self.user {
            // cannot block yourself
            if user.id! == userId { return }
            
            // if user is already blocked
            if let isBlocked = user.blockedUsers![userId] {
                if isBlocked { return }
            }
            
            // add the blocked user into the map in firestore
            Task {
                let docRef = db.collection("users").document(user.id!)
                
                do {
                    try await docRef.updateData([
                        "blockedUsers.\(userId)": true
                    ])
                    
                    // then add the user directly to the local map
                    DispatchQueue.main.async {
                        self.user!.blockedUsers![userId] = true
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func likePrompt(promptDate: String) {
        Task {
            do {
                // check if we're doing a like or an unlike
                var isLike = true
                
                if let likePrompts = user?.likedPrompts {
                    if let like = likePrompts[promptDate] {
                        isLike = !like
                    }
                }
                
                
                let userRef = self.db.collection("users").document(user!.id!)
                userRef.updateData([
                    "likedPrompts.\(promptDate)": isLike
                ])
                
                DispatchQueue.main.async {
                    var isLikeConcurrent = true
                    
                    if let likePrompts = self.user?.likedPrompts {
                        if let like = likePrompts[promptDate] {
                            isLikeConcurrent = !like
                        }
                    }
                    
                    if let _ = self.user?.likedPrompts {
                        self.user!.likedPrompts![promptDate] = isLikeConcurrent
                    } else {
                        self.user!.likedPrompts = [:]
                        self.user!.likedPrompts![promptDate] = isLikeConcurrent
                    }
                }
            }
        }
    }
    
    func likeShort(shortId: String) {
        Task {
            do {
                // check if we're doing a like or an unlike
                var isLike = true
                
                if let likeShorts = user?.likedShorts {
                    if let like = likeShorts[shortId] {
                        isLike = !like
                    }
                }
                
                let userRef = self.db.collection("users").document(user!.id!)
                userRef.updateData([
                    "likedShorts.\(shortId)": isLike
                ])
                
                DispatchQueue.main.async {
                    var isLikeConcurrent = true
                    
                    if let likeShorts = self.user?.likedShorts {
                        if let like = likeShorts[shortId] {
                            isLikeConcurrent = !like
                        }
                    }
                    
                    if let _ = self.user?.likedShorts {
                        self.user!.likedShorts![shortId] = isLikeConcurrent
                    } else {
                        self.user!.likedShorts = [:]
                        self.user!.likedShorts![shortId] = isLikeConcurrent
                    }
                }
            }
        }
    }
    
    // Rate limiting - limits firestore writes and blocks spamming in a singular user session. app is still prone to attacks in multiple app sessions (closing and re-opening)
    // Limits users to 5 writes in one minute
    func processFirestoreWrite() -> String? {
        
        // Cases:
        // 1. This is the first action - first action date doesn't exist
        // Set first action to Date()
        // set num actions = 1
        // 2. First action exists - currentAction is less than one minute from first action
        // Allow action if numActions < 5
        // set num actions += 1
        // Block action if numActions >= 5
        // 3. First action exists - current action is greater than one minute from first action
        // allow action
        // set first action date to Date()
        // set num action = 1
        
        if let firstActionDate = self.firstActionDate {
            
            // Get firstActionDate + 60 seconds
            let oneMinFromFirst = Calendar.current.date(byAdding: .second, value: 60, to: firstActionDate)
            
            if Date() < oneMinFromFirst! {
                if self.numActionsInLastMinute < 5 {
                    self.numActionsInLastMinute += 1
                } else {
                    return "Too many actions in one minute"
                }
            } else {
                self.firstActionDate = Date()
                self.numActionsInLastMinute = 1
            }
        } else {
            self.firstActionDate = Date()
            self.numActionsInLastMinute = 1
        }
        
        return nil
    }
}
