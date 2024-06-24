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
    
    // FocusedTopCommunityShorts - The Top three responses
    @Published var focusedTopCommunityShorts: [Short] = []
    // Cached Communnity shorts --
    var cachedTopCommunityShorts: [String : [Short]] = [:]
    
    // FocusedFullCommunityShorts - The full list of shorts for the selected prompt
    @Published var focusedFullCommunityShorts: [Short] = []
    // Cached full community shorts
    var cachedFullCommunityShorts: [String : [Short]] = [:]
    
    // If a single short preview is clicked on to view fully, this is that short
    @Published var focusedSingleShort: Short?
    // Determines if the focused short is from the user, or from the community
    var isFocusedShortOwned: Bool = false
    
    // focused comments, on the foccused single short
    @Published var focusedShortComments: [ShortComment] = []
    // cached comments [shortId : [ShortComment]]
    var cachedShortComments: [String : [ShortComment]] = [:]
    
    // Profile Picutres for community shorts (cached on device, they're small tho)
    @Published var communityProfilePictures: [String : UIImage] = [:]
    
    // Tracks the likes a user assigns to prompts throughout their app session. Will reset when the app is closed and re-opened.
    @Published var likedPrompts: [String : Bool] = [:]
    
    // Tracks the likes a user assigns to shorts throughout their app session. Will reset when the app is closed and re-opened. (TODO): can think about storing the likes in fb for better quality of life.
    // [Id : Bool] - if the id = true in the map, that short has been liked.
    @Published var likedShorts: [String : Bool] = [:]
    
    // tracks the text when a user is creating a comment
    @Published var commentText: String = ""
    
    
    // Vars for controlling views (sheets, popups etc..)
    
    @Published var isFullCommunityResposneSheetShowing: Bool = false
    
    @Published var isCreateCommentSheetShowing: Bool = false
    
    // Firestore
    let db = Firestore.firestore()
    
    // Storage
    let storage = Storage.storage()
    
    // Run this function when the HomeMainView first appears
    init() {
        // Retrieve the prompt for the selected day
        retrievePrompt()
        // Retrieve the signed in users short for the selected day
        retrieveSignedInUsersShort()
    }
    
    func retrievePrompt() {
        // null the previous prompt and image
        
        self.focusedPrompt = nil
        self.focusedPromptImage = nil
        
        
        // Get the date in YYYYMMDD format.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateIntString = formatter.string(from: self.promptSelectedDate)
        
        // First check if the prompt for the passed date is already cached.
        
        if let prompt = self.cachedPrompts[dateIntString] {
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
                    let imageRef = self.storage.reference().child("prompts/" + self.focusedPrompt!.date! + ".jpeg")
                    
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
    
    func retrieveSignedInUsersShort() {
        self.usersFocusedShort = nil
        
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
    
    func getCommunityAuthorsProfilePicutre(authorId: String) {
        // check if the author's PP is already cached
        if let _ = self.communityProfilePictures[authorId] {
            print("profile picture already cached")
            return
        }
        
        
        // else fetch it from storage and store it
        // Fetch the prompts image from storage
        let imageRef = self.storage.reference().child("profile_pictures/" + authorId + ".jpeg")
        
        Task {
            // download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            print("calling firestore for profile picture maaan")
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error downloading profile picture from storage: ", error.localizedDescription)
                    // There was an issue with the image or the image doesn't exist, either way set both prompt and promptImage back to nil
                    return
                } else {
                    DispatchQueue.main.async {
                        // Data for image is returned
                        let image = UIImage(data: data!)
                        self.communityProfilePictures[authorId] = image
                    }
                }
            }
        }
    }
    
    func retrieveTopCommunityShorts() {
        self.focusedTopCommunityShorts = []
        
        // make sure a prompt is focused
        if let prompt = self.focusedPrompt {
            // check if the top 3 responses for this prompt are already cached
            if let prompts = self.cachedTopCommunityShorts[prompt.date!] {
                self.focusedTopCommunityShorts = prompts
                return
            } else {
                // Otherwise the shorts are not cached for this prompt, fetch them from FB.
                Task {
                    do {
                        let querySnapshot = try await self.db.collection("shorts").whereField("date", isEqualTo: prompt.date!).order(by: "likeCount", descending: true).limit(to: 3).getDocuments()
                        DispatchQueue.main.async {
                            if querySnapshot.isEmpty {
                                print("no matching resposnes were found")
                                return
                            }
                            
                            // There will be at most 3 shorts, at least 1
                            for document in querySnapshot.documents {
                                if let short = try? document.data(as: Short.self) {
                                    self.focusedTopCommunityShorts.append(short)
                                    print("checking if the short has an id: ", short.id ?? "nil id lol")
                                    
                                    // get the profile picture for the author of the short
                                    self.getCommunityAuthorsProfilePicutre(authorId: short.authorId!)
                                } else {
                                    print("cant case document to short")
                                }
                            }
                            
                            // Cache the shorts retrieved
                            self.cachedTopCommunityShorts[prompt.date!] = self.focusedTopCommunityShorts
                        }
                        
                    } catch let error {
                        print("error fetching shorts from firestore: ", error.localizedDescription)
                    }
                }
            }
        } else {
            print("no focused prompt yet")
            return
        }
    }
    
    // Fetches the full list of community shorts for the focused prompt (Uses infinite scroll, aka we load 8 at a time then fetch the next 8)
    func retrieveFullCommunityShorts() {
        self.focusedFullCommunityShorts = []
        
        // Make sure a prompt is focused
        if let prompt = self.focusedPrompt {
            // Check if this prompt's full short list has been cached already
            if let prompts = self.cachedFullCommunityShorts[prompt.date!] {
                self.focusedFullCommunityShorts = prompts
                print("restoring cached shorts - full community shorts")
                return
            } else {
                // not cached, fetch the list from firestore
                print("no cache found - full community shorts")
                Task {
                    do {
                        let querySnapshot = try await self.db.collection("shorts").whereField("date", isEqualTo: prompt.date!).order(by: "rawTimestamp").limit(to: 8).getDocuments()
                        DispatchQueue.main.async {
                            if querySnapshot.isEmpty {
                                print("no matching resposnes were found")
                                return
                            }
                            
                            // There will be at most 8 shorts, at least 1
                            for document in querySnapshot.documents {
                                if let short = try? document.data(as: Short.self) {
                                    self.focusedFullCommunityShorts.append(short)
                                    
                                    // get the profile picture for the author of the short
                                    self.getCommunityAuthorsProfilePicutre(authorId: short.authorId!)
                                } else {
                                    print("cant case document to short")
                                }
                            }
                            // Cache the shorts retrieved
                            self.cachedFullCommunityShorts[prompt.date!] = self.focusedFullCommunityShorts
                        }
                        
                    } catch let error {
                        print("error fetching shorts from firestore: ", error.localizedDescription)
                    }
                }
            }
        } else {
            print("no focused prompt")
        }
    }
    
    // TODO : add infinite scroll to this lol fkk
    func retrieveShortComments(refresh: Bool) {
        self.focusedShortComments = []
        
        // make sure a short is focused
        if let short = self.focusedSingleShort {
            // if it's a refresh, skip the cache and retrieve from firestore
            if !refresh {
                // check cache
                if let comments = self.cachedShortComments[short.id!] {
                    self.focusedShortComments = comments
                    return
                }
            }
            
            Task {
                print("checking firestore for comments")
                do {
                    let querySnapshot = try await self.db.collection("shortComments").whereField("parentShortId", isEqualTo: short.id!).order(by: "rawTimestamp", descending: true).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no matching comments found")
                            self.cachedShortComments[short.id!] = []
                            return
                        }
                        
                        var comments: [ShortComment] = []
                        for document in querySnapshot.documents {
                            if let comment = try? document.data(as: ShortComment.self) {
                                comments.append(comment)
                                self.getCommunityAuthorsProfilePicutre(authorId: comment.authorId!)
                            }
                        }
                        
                        self.focusedShortComments = comments
                        self.cachedShortComments[short.id!] = comments
                    }
                } catch let error {
                    print("error fetching comments: ", error.localizedDescription)
                }
            }
        }
    }
    
    // called when a user clicks on a short preview, opening the full short view
    func focusSingleShort(short: Short, isOwned: Bool) {
        print("focusing a single short")
        self.focusedSingleShort = nil
        self.focusedSingleShort = short
        self.isFocusedShortOwned = isOwned
        self.retrieveShortComments(refresh: false)
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
            } else {
                // Else this is the first time a like is being sent, so we're going to actually update that prompts like count in firestore. Even if the user unlikes the prompt, the like will remain.
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
    
    func likeShort() {
        // get the id of the focused short
        var shortId = ""
        if let short = self.focusedSingleShort {
            shortId = short.id!
        } else {
            print("not focusing a short, cannot assign like")
            return
        }
        
        // if a short has already been liked / unliked, it's already in the map, just flip its value. Don't write to db.
        if let isLiked = self.likedShorts[shortId] {
            self.likedShorts[shortId]?.toggle()
            if isLiked {
                self.focusedSingleShort?.likeCount! -= 1
            } else {
                self.focusedSingleShort?.likeCount! += 1
            }
        } else {
            // otherwise it's the first time this short is being liked, so we're gonna update the db with a +1 like. Even if the user unlikes this short it wont change the like number lol.
            Task {
                do {
                    // have to get the id again, because this code doesn't run on main thread.
                    var shortIdAsync = ""
                    if let short = self.focusedSingleShort {
                        shortIdAsync = short.id!
                    }
                    
                    let shortRef = db.collection("shorts").document(shortIdAsync)
                    try await shortRef.updateData([
                        "likeCount": FieldValue.increment(Int64(1))
                    ])
                    DispatchQueue.main.async {
                        // have to get the id again for the main thread.
                        var shortIdMain = ""
                        if let short = self.focusedSingleShort {
                            shortIdMain = short.id!
                        }
                        self.likedShorts[shortIdMain] = true
                        self.focusedSingleShort?.likeCount! += 1
                    }
                } catch let error {
                    print("error adding like to short: ", error.localizedDescription)
                }
            }
        }
    }
    
    func submitComment(user: User) {
        // if the comment text is empty, do nothing
        if self.commentText.isEmpty { return }
        
        if let short = self.focusedSingleShort {
            let shortComment = ShortComment(parentShortId: short.id!, rawTimestamp: Timestamp(), authorId: user.id, authorFirstName: user.firstName, authorLastName: user.lastName, authorProfilePictureUrl: user.profilePictureUrl, commentRawText: self.commentText)
            
            Task {
                // write the short comment to firestore
                do {
                    try db.collection("shortComments").addDocument(from: shortComment)
                    print("short Comment written to firestore")
                } catch let error {
                    print("error writing comment to firestore: ", error.localizedDescription)
                }
                
                // update the short comment count
                do {
                    let shortRef = db.collection("shorts").document(short.id!)
                    try await shortRef.updateData([
                        "commentCount": FieldValue.increment(Int64(1))
                    ])
                } catch let error {
                    print("error updating short comment count: ", error.localizedDescription)
                }
                
                // refresh the comment list for focused short
                DispatchQueue.main.async {
                    self.retrieveShortComments(refresh: true)
                    self.commentText = ""
                    self.isCreateCommentSheetShowing = false
                }
            }
        }
    }
    
    func clearShortOnSignOut() {
        self.usersFocusedShort = nil
        self.cachedUserShorts = [:]
    }
    
    
    // limit comment length function
    
    
    // Adds community shorts to the focused Prompt (For testing)
    // For now they are hardcoded, but eventually will be openAI response.
    func addCommunityShorts() {
        // Ensure a prompt is focused
        if let prompt = self.focusedPrompt {
            // Build a couple of short objects
            
            let short1 = Short(date: prompt.date!, rawTimestamp: Timestamp(date: Date() - Double.random(in: 1...1000)), authorId: "NfoTqlNKlqsZmObbP90z", authorFirstName: "George", authorLastName: "Kittle", authorProfilePictureUrl: "asdasd", authorNumShorts: 12, authorNumLikes: 72, promptRawText: prompt.promptRawText!, shortRawText: "This is a test and isn't actually for popular purposes yok jnow.", likeCount: 1, commentCount: 14)
            
            let short2 = Short(date: prompt.date!, rawTimestamp: Timestamp(date: Date() - Double.random(in: 1...1000)), authorId: "S0mE0rS3RfSY2O21Yyk9", authorFirstName: "Josh", authorLastName: "Green", authorProfilePictureUrl: "asdasd", authorNumShorts: 32, authorNumLikes: 12, promptRawText: prompt.promptRawText!, shortRawText: "A second test for testing purposes is like the ultimate thing isnt it.", likeCount: 14, commentCount: 1)
            
            let short3 = Short(date: prompt.date!, rawTimestamp: Timestamp(date: Date() - Double.random(in: 1...1000)), authorId: "pWXYaNd6cAsAM9GxpsN8", authorFirstName: "Kelly", authorLastName: "Ball", authorProfilePictureUrl: "asdasd", authorNumShorts: 82, authorNumLikes: 72, promptRawText: prompt.promptRawText!, shortRawText: "This short is from Kelly Ball and I really like the prompt. I don't know how to write anything though lol.", likeCount: 54, commentCount: 31)
            
            let shorts = [short1, short2, short3]
            // Write all three shorts to firestore
            for short in shorts {
                Task {
                    // Write the short to firebase
                    do {
                        try db.collection("shorts").addDocument(from: short)
                        print("short written to firestore")
                    } catch let error {
                        print("error writign short to firestore: ", error.localizedDescription)
                    }
                    
                    // Update the prompt response count
                    do {
                        let promptRef = db.collection("prompts").document(prompt.date!)
                        try await promptRef.updateData([
                            "shortCount": FieldValue.increment(Int64(1))
                        ])
                        print("shortCount updated +1")
                    } catch let error {
                        print("error updating short count on prompt: ", error.localizedDescription)
                    }
                }
            }
        } else {
            print("no focused prompt")
        }
    }
}
