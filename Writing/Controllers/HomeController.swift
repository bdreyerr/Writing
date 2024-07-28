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
    
    
    // The author of the focused short (used to display stats about the author)
    @Published var focusedShortAuthor: User?
    // Cached authors of previosuly focused shorts
    var cachedShortAuthors: [String : User] = [:]
    
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
    
    // Pagination
    @Published var lastDocListShorts: QueryDocumentSnapshot?
    var cachedLastDocListShorts : [String : QueryDocumentSnapshot] = [:]
    
    @Published var lastDocComments: QueryDocumentSnapshot?
    var cachedLastDocComments : [String : QueryDocumentSnapshot] = [:]
    
    // Vars for controlling views (sheets, popups etc..)
    
    @Published var isFullCommunityResposneSheetShowing: Bool = false
    @Published var isCreateCommentSheetShowing: Bool = false
    @Published var isReportPromptAlertShowing: Bool = false
    @Published var isReportShortAlertShowing: Bool = false
    @Published var isReportCommentAlertShowing: Bool = false
    @Published var areNoShortsLeftToLoad: Bool = false
    @Published var areNoCommentsLeftToLoad: Bool = false
    @Published var listShortSortingMethod: Int = 0
    
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
                            // making sure the focusedPrompt exists and has a date
                            if let prompt = self.focusedPrompt {
                                if let date = prompt.date {
                                    self.cachedPromptImages[date]  = image
                                }
                            }
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
    
    func retrieveTopCommunityShorts(blockedUsers: [String : Bool]) {
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
                                    // Before adding the short, make sure the user isn't blocking the author of one of the shorts (this will result in less than 3 shorts showing up as the top shorts).
                                    if let isBlocked = blockedUsers[short.authorId ?? "0"] {
                                        if isBlocked { continue }
                                    }
                                    
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
    
    // Fetches the full list of community shorts for the focused prompt
    func retrieveFullCommunityShorts(blockedUsers: [String : Bool]) {
        self.focusedFullCommunityShorts = []
        self.lastDocListShorts = nil
        
        // Make sure a prompt is focused
        if let prompt = self.focusedPrompt {
            // Check if this prompt's full short list has been cached already
            if let prompts = self.cachedFullCommunityShorts[prompt.date!] {
                self.focusedFullCommunityShorts = prompts
                // if the shorts are cached, the last Document Snapshot should also be cached
                if let querySnapshotDoc = self.cachedLastDocListShorts[prompt.date!] {
                    self.lastDocListShorts = querySnapshotDoc
                }
                
                print("restoring cached shorts - full community shorts")
                return
            } else {
                // not cached, fetch the list from firestore
                print("no cache found - full community shorts")
                Task {
                    do {
                        let querySnapshot = try await self.db.collection("shorts").whereField("date", isEqualTo: prompt.date!).order(by: "rawTimestamp", descending: true).limit(to: 8).getDocuments()
                        
                        DispatchQueue.main.async {
                            if querySnapshot.isEmpty {
                                print("no matching resposnes were found")
                                self.areNoShortsLeftToLoad = true
                                return
                            }
                            
                            // There will be at most 8 shorts, at least 1
                            for document in querySnapshot.documents {
                                if let short = try? document.data(as: Short.self) {
                                    // Check if the author is being blocked by the user
                                    if let isBlocked = blockedUsers[short.authorId!] {
                                        if isBlocked { continue }
                                    }
                                    
                                    self.focusedFullCommunityShorts.append(short)
                                    
                                    // get the profile picture for the author of the short
                                    self.getCommunityAuthorsProfilePicutre(authorId: short.authorId!)
                                } else {
                                    print("cant case document to short")
                                }
                            }
                            
                            // get the last document snapshot (for pagination)
                            guard let lastSnapshot = querySnapshot.documents.last else {
                                // The collection is empty.
                                return
                            }
                            self.lastDocListShorts = lastSnapshot
                            
                            // then add last doc to the cache
                            self.cachedLastDocListShorts[prompt.date!] = lastSnapshot
                            
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
    
    func retrieveNextFullCommunityShorts(blockedUsers: [String : Bool]) {
        // Make sure a prompt is focused
        if let prompt = self.focusedPrompt {
            Task {
                do {
                    let querySnapshot = try await self.db.collection("shorts").whereField("date", isEqualTo: prompt.date!).order(by: "rawTimestamp", descending: true).limit(to: 8).start(afterDocument: self.lastDocListShorts!).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no matching resposnes were found")
                            self.areNoShortsLeftToLoad = true
                            return
                        }
                        
                        // There will be at most 8 shorts, at least 1
                        for document in querySnapshot.documents {
                            if let short = try? document.data(as: Short.self) {
                                // Check if the author is being blocked by the user
                                if let isBlocked = blockedUsers[short.authorId!] {
                                    if isBlocked { continue }
                                }
                                
                                self.focusedFullCommunityShorts.append(short)
                                
                                // get the profile picture for the author of the short
                                self.getCommunityAuthorsProfilePicutre(authorId: short.authorId!)
                            } else {
                                print("cant case document to short")
                            }
                        }
                        
                        // get the last document snapshot (for pagination)
                        guard let lastSnapshot = querySnapshot.documents.last else {
                            // The collection is empty.
                            return
                        }
                        self.lastDocListShorts = lastSnapshot
                        // then add last doc to the cache
                        self.cachedLastDocListShorts[prompt.date!] = lastSnapshot
                        
                        // Cache the shorts retrieved
                        self.cachedFullCommunityShorts[prompt.date!] = self.focusedFullCommunityShorts
                    }
                } catch {
                    print("error getting next shorts: ", error.localizedDescription)
                }
            }
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
                    if let querySnapshotDoc = self.cachedLastDocComments[short.id!] {
                        self.lastDocComments = querySnapshotDoc
                    }
                    return
                }
            }
            
            Task {
                print("checking firestore for comments")
                do {
                    let querySnapshot = try await self.db.collection("shortComments").whereField("parentShortId", isEqualTo: short.id!).order(by: "rawTimestamp", descending: true).limit(to: 8).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no matching comments found")
                            self.cachedShortComments[short.id!] = []
                            self.areNoCommentsLeftToLoad = true
                            return
                        }
                        
                        var comments: [ShortComment] = []
                        for document in querySnapshot.documents {
                            if let comment = try? document.data(as: ShortComment.self) {
                                comments.append(comment)
                                self.getCommunityAuthorsProfilePicutre(authorId: comment.authorId!)
                            }
                        }
                        
                        guard let lastSnapshot = querySnapshot.documents.last else {
                            // The collection is empty.
                            return
                        }
                        
                        self.lastDocComments = lastSnapshot
                        self.cachedLastDocComments[short.id!] = lastSnapshot
                        
                        self.focusedShortComments = comments
                        self.cachedShortComments[short.id!] = comments
                    }
                } catch let error {
                    print("error fetching comments: ", error.localizedDescription)
                }
            }
        }
    }
    
    func retrieveNextShortComments() {
        if let short = self.focusedSingleShort {
            Task {
                do {
                    let querySnapshot = try await self.db.collection("shortComments").whereField("parentShortId", isEqualTo: short.id!).order(by: "rawTimestamp", descending: true).limit(to: 8).start(afterDocument: self.lastDocComments!).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no matching comments found")
                            self.areNoCommentsLeftToLoad = true
                            return
                        }
                        
                        var comments: [ShortComment] = []
                        for document in querySnapshot.documents {
                            if let comment = try? document.data(as: ShortComment.self) {
                                comments.append(comment)
                                self.getCommunityAuthorsProfilePicutre(authorId: comment.authorId!)
                            }
                        }
                        
                        guard let lastSnapshot = querySnapshot.documents.last else {
                            // The collection is empty.
                            return
                        }
                        
                        self.lastDocComments = lastSnapshot
                        self.cachedLastDocComments[short.id!] = lastSnapshot
                        
                        for comment in comments {
                            self.focusedShortComments.append(comment)
                        }
//                        self.focusedShortComments = comments
                        self.cachedShortComments[short.id!] = self.focusedShortComments
                    }
                } catch let error {
                    print("error fetching next comments: ", error.localizedDescription)
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
        self.focusAuthor(authorId: short.authorId ?? "1")
    }
    
    func focusAuthor(authorId: String) {
        // Check if the author is already cached
        if let author = self.cachedShortAuthors[authorId] {
            self.focusedShortAuthor = author
            return
        }
        
        // Fetch the author from firestore, store it in the focused author var and cache it
        Task {
            let docRef = self.db.collection("users").document(authorId)
            
            do {
                let author = try await docRef.getDocument(as: User.self)
                
                DispatchQueue.main.async {
                    self.focusedShortAuthor = author
                    self.cachedShortAuthors[authorId] = author
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func likePrompt(usersPromptLikes: [String : Bool]) {
        // make sure a prompt is focused
        if let prompt = self.focusedPrompt {
            // Write to Firestore (Prompt - Adding / Subtracting like count)
            Task {
                do {
                    var isLike = true
                    if let like = usersPromptLikes[prompt.date!] {
                        if like == true {isLike = false} else {isLike = true}
                    }
                    
                    let promptRef = db.collection("prompts").document(prompt.date!)
                    try await promptRef.updateData([
                        "likeCount": FieldValue.increment(Int64(isLike ? 1 : -1))
                    ])
                    // Update published vars - prompt
                    DispatchQueue.main.async {
                        
                        var isLikeConcurrent = true
                        if let like = usersPromptLikes[prompt.date!] {
                            if like == true {isLikeConcurrent = false} else {isLikeConcurrent = true}
                        }
                        // Add / Subtract 1 to the focusedPrompt, so it updates on the view
                        self.focusedPrompt?.likeCount! += isLikeConcurrent ? 1 : -1
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func likeShort(usersShortsLikes: [String : Bool]) {
        // ensure a short is focused
        if let short = self.focusedSingleShort {
            Task {
                do {
                    // determine like or unlike
                    var isLike = true
                    if let like = usersShortsLikes[short.id!] {
                        if like == true {isLike = false} else {isLike = true}
                    }
                    
                    let shortRef = db.collection("shorts").document(short.id!)
                    try await shortRef.updateData([
                        "likeCount": FieldValue.increment(Int64(isLike ? 1 : -1))
                    ])
                    
                    DispatchQueue.main.async {
                        var isLikeConcurrent = true
                        if let like = usersShortsLikes[short.id!] {
                            if like == true {isLikeConcurrent = false} else {isLikeConcurrent = true}
                        }
                        // Add / Subtract 1 to the focusedShort, so it updates on the view
                        self.focusedSingleShort?.likeCount! += isLikeConcurrent ? 1 : -1
                        
                        // update focused top community shorts
                        // find the corresponding short in the array (can be 1 of 3)
                        for topShort in self.focusedTopCommunityShorts {
                            if topShort.id! == short.id! {
                                
                            }
                        }
                        
                        // update the users Shorts too (the user might have liked their own short)
                        if let userShort = self.usersFocusedShort {
                            if userShort.id == short.id! {
                                self.usersFocusedShort!.likeCount! += isLikeConcurrent ? 1 : -1
                            }
                        }
                        
                        // update users cached shorts
                        if let usersCachedShort = self.cachedUserShorts[short.date!] {
                            self.cachedUserShorts[short.date!]!.likeCount! += isLikeConcurrent ? 1 : -1
                        }
                        
                        
                        // check focusedTopCommunityShorts
                        for i in 0..<self.focusedTopCommunityShorts.count {
                            if self.focusedTopCommunityShorts[i].id == short.id! {
                                self.focusedTopCommunityShorts[i].likeCount! += isLikeConcurrent ? 1 : -1
                                
                                // then update the cache since it exists too
                                if let cachedArrayOfShorts = self.cachedTopCommunityShorts[short.date!] {
                                    for i in 0..<cachedArrayOfShorts.count {
                                        if cachedArrayOfShorts[i].id! == short.id! {
                                            self.cachedTopCommunityShorts[short.date!]![i].likeCount! += isLikeConcurrent ? 1 : -1
                                        }
                                    }
                                }
                            }
                        }
                        
                        // check focusedFullCommunityShorts
                        for i in 0..<self.focusedFullCommunityShorts.count {
                            if self.focusedFullCommunityShorts[i].id == short.id! {
                                self.focusedFullCommunityShorts[i].likeCount! += isLikeConcurrent ? 1 : -1
                                
                                // then update the cache since it exists too
                                if let cachedArrayOfShorts = self.cachedFullCommunityShorts[short.date!] {
                                    for i in 0..<cachedArrayOfShorts.count {
                                        if cachedArrayOfShorts[i].id! == short.id! {
                                            self.cachedFullCommunityShorts[short.date!]![i].likeCount! += isLikeConcurrent ? 1 : -1
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                } catch let error {
                    print(error.localizedDescription)
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
    
    func reportPrompt(reportReason: String) {
        // ensure a user is authd
        if let user = Auth.auth().currentUser {
            // ensure a prompt is focused
            if self.focusedPrompt == nil { return }
            
            // Else write the following info in a document into firestore
            // Prompt date
            // Report reason
            // Reporting user id
            // Date(timestamp) of report
            
            let promptDate: String = (self.focusedPrompt?.date!)!
            let reportingUserId = user.uid
            let date = Timestamp()
            
            Task {
                do {
                    let ref = try await db.collection("promptReports").addDocument(data: [
                        "promptDate": promptDate,
                        "reportReason": reportReason,
                        "reportingUserId": reportingUserId,
                        "date": date
                    ])
                    print("prompt report successfuly filed into firestore: ", ref.documentID)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("no auth")
        }
    }
    
    func reportShort(reportReason: String) {
        // ensure a user is authd
        if let user = Auth.auth().currentUser {
            // ensure a short is focused
            if self.focusedSingleShort == nil {
                return
            }
            
            // Write the following info into a document into firestore
            // Short Id
            // Report Reason
            // Reporting user id
            // Date(timestamp) of report
            
            let focusedShortId : String = (self.focusedSingleShort?.id!)!
            let reportingUserId = user.uid
            let date = Timestamp()
            
            Task {
                do {
                    let ref = try await db.collection("shortReports").addDocument(data: [
                        "shortId": focusedShortId,
                        "reportReason": reportReason,
                        "reportingUserId": reportingUserId,
                        "date": date
                    ])
                    print("short report successfuly filed into firestore: ", ref.documentID)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("no auth")
        }
    }
    
    func reportComment(reportReason: String, commentId: String) {
        // ensure a user is authd
        if let user = Auth.auth().currentUser {
            
            // Write the following info into a document into firestore
            // Comment Id
            // Report Reason
            // Reporting user id
            // Date(timestamp) of report
            
            let reportingUserId = user.uid
            let date = Timestamp()
            
            Task {
                do {
                    let ref = try await db.collection("commentReports").addDocument(data: [
                        "commentId": commentId,
                        "reportReason": reportReason,
                        "reportingUserId": reportingUserId,
                        "date": date
                    ])
                    print("comment report successfuly filed into firestore: ", ref.documentID)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("no auth")
        }
    }
    
    func sortFocusedListShorts(isByDate: Bool, isByLikes: Bool) {
        // make sure there are focused shorts
        if isByDate{
            self.focusedFullCommunityShorts = self.focusedFullCommunityShorts.sorted(by: {$0.rawTimestamp!.dateValue() > $1.rawTimestamp!.dateValue()} )
            self.listShortSortingMethod = 0
        }
        if isByLikes {
            self.focusedFullCommunityShorts = self.focusedFullCommunityShorts.sorted(by: {$0.likeCount! > $1.likeCount!} )
            self.listShortSortingMethod = 1
        }
    }
    
    func convertTitleIntToString(int : Int) -> String {
        switch int {
        case 0:
            return "Pupil"
        case 1:
            return "Novice Author"
        case 2:
            return "Storyteller"
        case 3:
            return "Scribe"
        case 4:
            return "Seasoned Wordsmith"
        case 5:
            return "Accomplished Novelist"
        case 6:
            return "Renowned Author"
        case 7:
            return "Literary Master"
        default:
            return ""
        }
    }
    
    // Call this function when you need to reload a user short which is updated or deleted.
    func clearEditedOrRemovedShortFromCache(shortDate: String) {
        if let removedValue = self.cachedUserShorts.removeValue(forKey: shortDate) {
            print("Removed value: \(removedValue)")
        } else {
            print("Key not found")
        }
    }
    
    // limits the number of characters you can write when editing your short (2500 characters)
    func limitCommentTextLength(_ upper: Int) {
        if self.commentText.count > upper {
            self.commentText = String(self.commentText.prefix(upper))
        }
    }
    
    
    
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
