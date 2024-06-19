//
//  HomeController.swift
//  Writing
//
//  Created by Ben Dreyer on 6/15/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HomeController : ObservableObject {
    // The day in focus, determines which prompt should be shown.
    @Published public var promptSelectedDate: Date = Date()
    
    // The prompt currently being displayed on the home view.
    @Published var focusedPrompt: Prompt?
    @Published var focusedPromptImage: UIImage?
    // Cached Prompts. (avoid making firebase call each time)
    var cachedPrompts: [String : Prompt] = [:]
    var cachedPromptImages: [String : UIImage] = [:]
    
    // UsersFocusedShort - Is nil if the signed in user hasn't made a short for the focused prompt.
    @Published var usersFocusedShort: Short?
    // Cached UsersShorts
    var cachedUserShorts: [String : Short] = [:]
    
    // FocusedCommunityShorts
    
    // Cached Communnity shorts --
    
    // Tracks the likes a user assigns to prompts throughout their app session. Will reset when the app is closed and re-opened.
    @Published var likedPrompts: [String : Bool] = [:]
    
    
    
    // Firestore
    let db = Firestore.firestore()
    
    // Storage
    let storage = Storage.storage()
    
    // Run this function when the HomeMainView first appears
    init() {
        // Retrieve the prompt for the current day
        retrievePrompt()
        retrieveSignedInUsersShort()
        print("testing it ran")
    }
    
    func retrievePrompt() {
        // null the previous prompt and image
        DispatchQueue.main.async {
            self.focusedPrompt = nil
            self.focusedPromptImage = nil
        }
        
        // Get the date in YYYYMMDD format.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateIntString = formatter.string(from: self.promptSelectedDate)
        print(dateIntString)
        
        // First check if the prompt for the passed date is already cached.
        
        if let prompt = self.cachedPrompts[dateIntString] {
            DispatchQueue.main.async {
                // Prompt is already cached
                self.focusedPrompt = prompt
                
                // double check the image is also cached.
                if let promptImage = self.cachedPromptImages[dateIntString] {
                    self.focusedPromptImage = promptImage
                } else {
                    // Image isn't cached so fetch both the prompt and Image again from DB.
                    self.focusedPrompt = nil
                    self.focusedPromptImage = nil
                }
            }
            return
        }
        
        // Retrieve today's prompt from firestore (if it exists - fallback to a default if it doesn't exist)
        // User does not need to be validated for this.
        Task {
            let docRef = db.collection("prompts").document(dateIntString)
            do {
                let fetchedPrompt = try await docRef.getDocument(as: Prompt.self)
                
                DispatchQueue.main.async {
                    self.focusedPrompt = fetchedPrompt
                    //                    print("testing concurrency: ")
                    //                    print(self.focusedPrompt!.promptRawText ?? "nothing yet")
                    
                    // Add the prompt to the cache
                    self.cachedPrompts[self.focusedPrompt!.date!] = self.focusedPrompt!
                    
                    // Fetch the prompts image from storage
                    let imageRef = self.storage.reference().child("prompts/" + self.focusedPrompt!.date! + ".png")
                    
                    // download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("error downloading image from storage: ", error.localizedDescription)
                            // There was an issue with the image or the image doesn't exist, either way set both prompt and promptImage back to nil
                            self.focusedPrompt = nil
                            self.focusedPromptImage = nil
                            return
                        } else {
                            // Data for image is returned
                            let image = UIImage(data: data!)
                            self.focusedPromptImage = image
                            
                            // Add image to cache
                            self.cachedPromptImages[self.focusedPrompt!.date!]  = image
                        }
                    }
                }
            } catch {
                print("error decoding prompt, or it wasnt found: \(error)")
                DispatchQueue.main.async {
                    // Set focusedPrompt back to nil so that the view can update appropriately
                    self.focusedPrompt = nil
                    self.focusedPromptImage = nil
                    return
                }
            }
        }
        
    }
    
    // Test this, it's untested lol.
    func retrieveSignedInUsersShort() {
        DispatchQueue.main.async {
            self.usersFocusedShort = nil
        }
        
        // Get the date in a string (YYYYMMDD)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateIntString = formatter.string(from: self.promptSelectedDate)
        
        // Check if the users short is already in the cache before fetching from Firestore
        if let short = self.cachedUserShorts[dateIntString] {
            DispatchQueue.main.async {
                self.usersFocusedShort = short
                print("assigned previously cached user short - skipping firebase read")
            }
            return
        }
        
        // Get the user, we need to access the user ID when making the firebase call.
        if let user = Auth.auth().currentUser {
            Task {
                do {
                    let querySnapshot = try await db.collection("shorts").whereField("authorId", isEqualTo: user.uid).whereField("date", isEqualTo: dateIntString).getDocuments()
                    // there should only be one document if any
                    // if empty, reset the focusedshort to nil
                    DispatchQueue.main.async {
                        if querySnapshot.documents.isEmpty {
                            self.usersFocusedShort = nil
                        }
                        
                        for document in querySnapshot.documents {
                            if let short = try? document.data(as: Short.self) {
                                print("we got the short for the selected prompt: ", short.shortRawText!)
                                self.usersFocusedShort = short
                                
                                // Add the short to the cache
                                self.cachedUserShorts[dateIntString] = short
                            } else {
                                print("can't get short")
                                self.usersFocusedShort = nil
                            }
                        }
                    }
                }
            }
        }
    }
    
    func likePrompt() {
        // If a prompt is focused, process it for a like.
        if let prompt = self.focusedPrompt {
            // if a prompt is already liked, it's in the map, and just set it to false
            if let isLiked = self.likedPrompts[prompt.date!] {
                if isLiked == true {
                    self.focusedPrompt?.likeCount! -= 1
                    self.likedPrompts[prompt.date!] = false
                    return
                }
                if isLiked == false {
                    self.focusedPrompt?.likeCount! += 1
                    self.likedPrompts[prompt.date!] = true
                    return
                }
            }
            
            Task {
                do {
                    let promptRef = db.collection("prompts").document(prompt.date!)
                    try await promptRef.updateData([
                        "likeCount": FieldValue.increment(Int64(1))
                    ])
                    DispatchQueue.main.async {
                        // Add the like to the map
                        self.likedPrompts[prompt.date!] = true
                        // Add 1 to the focusedPrompt, so it updates on the view
                        self.focusedPrompt?.likeCount! += 1
                    }
                } catch let error {
                    print("error adding like to prompt: ", error.localizedDescription)
                }
            }
        }
    }
}
