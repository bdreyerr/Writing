//
//  ProfileController.swift
//  Writing
//
//  Created by Ben Dreyer on 6/15/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation
import PhotosUI
import SwiftUI

class ProfileController : ObservableObject {
    
    // Sorted by date written (default)
    @Published var shorts: [Short] = []
    
    // Sorted by Like Count
    @Published var shortsByLikeCount: [Short] = []
    
    // Sorted by Prompt Date
    @Published var shortsByPromptDate: [Short] = []
    
    // Sorting method (0 = byDateWritten, 1 = byLikeCount, 2 = byPromptDate)
    @Published var shortsSortingMethod: Int = 0
    
    // Used to display in rows of three in the view (grid)
    var chunksOfShorts: [ArrayOfShort] = []
    @Published var promptImages: [String : UIImage] = [:]
    
    @Published var focusedShort: Short?
    
    @Published var newShortText: String = ""
    let characterLimit = 2500
    
    // Changing profile picture vars
    @Published var data: Data?
    @Published var selectedItem: [PhotosPickerItem] = []
    
    // Prompt suggestion
    @Published var suggestedPromptText: String = ""
    
    // TODO(ordering) : figure out how to retrieve prompts based on what ordering is going on
    
    // Pagination - Sorted by date written
    @Published var lastDoc: QueryDocumentSnapshot?
    
    // Pagination - Sorted by like count
    @Published var lastDocByLikeCount: QueryDocumentSnapshot?
    
    // Pagination - Sorted by prompt date
    @Published var lastDocByPromptDate: QueryDocumentSnapshot?
    
    // vars that control the view
    @Published var isSignUpViewShowing: Bool = false
    @Published var isSettingsShowing: Bool = false
    @Published var showSidebar: Bool = false
    @Published var isConfirmShortDelteAlertShowing: Bool = false
    
    @Published var isFocusedShortSheetShowing: Bool = false
    @Published var isChangeNameAlertShowing: Bool = false
    @Published var isChangePhotoSheetShowing: Bool = false
    @Published var areNoShortsLeftToLoad: Bool = false
    
    @Published var contributions: [Int] = []
    @Published var contributionCount: Int = 0
    
    // Firebase
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init() {
        print("init profile controller")
        retrieveShorts()
    }
    
    // Retrieves shorts the user has written, to be displayed on their profile
    func retrieveShorts() {
        self.shorts = []
        self.chunksOfShorts = []
        
        if let user = Auth.auth().currentUser {
            // Lookup firestore shorts collection that match userId
            Task {
                do {
                    
                    let query: Query
                    
                    if shortsSortingMethod == 0 {
                        query = db.collection("shorts").whereField("authorId", isEqualTo: user.uid).order(by: "rawTimestamp", descending: true)
                    } else if shortsSortingMethod == 1 {
                        query = db.collection("shorts").whereField("authorId", isEqualTo: user.uid).order(by: "likeCount", descending: true)
                    } else {
                        query = db.collection("shorts").whereField("authorId", isEqualTo: user.uid).order(by: "date", descending: true)
                    }
                    
                    let querySnapshot = try await query.limit(to: 9).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no shorts returned")
                            self.areNoShortsLeftToLoad = true
                            return
                        }
                        
                        for document in querySnapshot.documents {
                            if let short = try? document.data(as: Short.self) {
                                // add the short to the local array, and fetch it's prompt and picture
                                self.retrievePromptImage(date: short.date!)
                                print("profile - appended short to list")
                                
                                if self.shortsSortingMethod == 0 {
                                    self.shorts.append(short)
                                } else if self.shortsSortingMethod == 1 {
                                    self.shortsByLikeCount.append(short)
                                } else {
                                    self.shortsByPromptDate.append(short)
                                }
                                
                            }
                        }
                        
                        // get the last doc (for pagination)
                        guard let lastSnapshot = querySnapshot.documents.last else {
                            // The collection is empty.
                            print("error getting the last document snapshot")
                            return
                        }
                        
                        if self.shortsSortingMethod == 0 {
                            self.lastDoc = lastSnapshot
                        } else if self.shortsSortingMethod == 1 {
                            self.lastDocByLikeCount = lastSnapshot
                        } else {
                            self.lastDocByPromptDate = lastSnapshot
                        }
                        
                        
                        self.resetChunks()
                    }
                } catch let error {
                    print("error retrieving the user's shorts: ", error.localizedDescription)
                }
            }
        } else {
            print("no auth user yet.")
        }
    }
    
    // the function to call when loading the next N shrots on the profile
    func retrieveNextShorts() {
        if let user = Auth.auth().currentUser {
            Task {
                do {
                    
                    let query: Query
                    let lastDoc: QueryDocumentSnapshot
                    
                    if shortsSortingMethod == 0 {
                        query = db.collection("shorts").whereField("authorId", isEqualTo: user.uid).order(by: "rawTimestamp", descending: true)
                        lastDoc = self.lastDoc!
                    } else if shortsSortingMethod == 1 {
                        query = db.collection("shorts").whereField("authorId", isEqualTo: user.uid).order(by: "likeCount", descending: true)
                        lastDoc = self.lastDocByLikeCount!
                    } else {
                        query = db.collection("shorts").whereField("authorId", isEqualTo: user.uid).order(by: "date", descending: true)
                        lastDoc = self.lastDocByPromptDate!
                    }
                    
                    
                    let querySnapshot = try await query.limit(to: 9).start(afterDocument: lastDoc).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            self.areNoShortsLeftToLoad = true
                            return
                        }
                        
                        for document in querySnapshot.documents {
                            if let short = try? document.data(as: Short.self) {
                                // add the short to the local array, and fetch it's prompt and picture
                                self.retrievePromptImage(date: short.date!)
                                print("profile - appended short to list")
                                
                                if self.shortsSortingMethod == 0 {
                                    self.shorts.append(short)
                                } else if self.shortsSortingMethod == 1 {
                                    self.shortsByLikeCount.append(short)
                                } else {
                                    self.shortsByPromptDate.append(short)
                                }
                            }
                        }
                        
                        // get the last doc (for pagination)
                        guard let lastSnapshot = querySnapshot.documents.last else {
                            // The collection is empty.
                            print("error getting the last document snapshot")
                            return
                        }
                        
                        if self.shortsSortingMethod == 0 {
                            self.lastDoc = lastSnapshot
                        } else if self.shortsSortingMethod == 1 {
                            self.lastDocByLikeCount = lastSnapshot
                        } else {
                            self.lastDocByPromptDate = lastSnapshot
                        }
                        
                        
                        self.resetChunks()
                    }
                } catch let error {
                    print("error retrieving the user's shorts: ", error.localizedDescription)
                }
            }
        }
    }
    
    func switchSortingMethod() {
        self.areNoShortsLeftToLoad = false
        
        // the var should already be set.
        print("switching sorting method")
        
        if shortsSortingMethod == 0 {
            if shorts.isEmpty {
                retrieveShorts()
            } else {
                resetChunks()
            }
        } else if shortsSortingMethod == 1 {
            if shortsByLikeCount.isEmpty {
                retrieveShorts()
            } else {
                resetChunks()
            }
        } else if shortsSortingMethod == 2 {
            if shortsByPromptDate.isEmpty {
                retrieveShorts()
            } else {
                resetChunks()
            }
        }
    }
    
    func resetChunks() {
        // clear the chunks
        self.chunksOfShorts = []
        
        var chunks: [[Short]] = []
        if self.shortsSortingMethod == 0 {
            chunks = self.shorts.chunked(into: 3)
        } else if self.shortsSortingMethod == 1 {
            chunks = self.shortsByLikeCount.chunked(into: 3)
        } else {
            chunks = self.shortsByPromptDate.chunked(into: 3)
        }
        
//                        let chunks = self.shorts.chunked(into: 3)
        for chunk in chunks {
            let arrayofShort = ArrayOfShort(shorts: chunk)
            self.chunksOfShorts.append(arrayofShort)
        }
    }
    
    func retrievePromptImage(date: String) {
        // check if the image is already in the cache / map
        if let _ = self.promptImages[date] {
            print("image already cached")
            return
        }
        
        // TODO: share the image cache from the home controller in this function, and return the image there. Can avoid some extra storage calls
        

        // Fetch image from firestore
        Task {
            // Fetch the prompts image from storage
            let imageRef = self.storage.reference().child("prompts/" + date + ".jpeg")
            
            // download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error downloading image from storage: ", error.localizedDescription)
                    // There was an issue with the image or the image doesn't exist, either way set both prompt and promptImage back to nil
                    return
                } else {
                    // Data for image is returned
                    let image = UIImage(data: data!)
                    // Add image to cache
                    self.promptImages[date] = image
                }
            }
        }
    }
    
    func focusShort(short: Short) {
        self.focusedShort = nil
        self.focusedShort = short
        self.isFocusedShortSheetShowing = true
    }
    
    // Update the focused short to the new text stored in this controller
    func editShort() {
        // make sure a short is focused
        if let short = self.focusedShort {
            // Make sure the text has changed
            if self.newShortText == short.shortRawText! {
                print("the text didn't change at all")
                return
            }
            
            // Check text length
            if self.newShortText.count == 0 {
                print("new short text is empty")
                return
            }
            
            // Else update Firestore
            Task {
                let docRef = db.collection("shorts").document(short.id!)
                
                do {
                    try await docRef.updateData([
                        "shortRawText": self.newShortText
                    ])
                    print("changed text")
                } catch let error {
                    print("error updating short: ", error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    // Refresh the shorts stored on profile
                    self.retrieveShorts()
                    // close the views
                    self.isFocusedShortSheetShowing = false
                    // nil the focused short
                    self.focusedShort = nil
                }
            }
        }
    }
    
    // use this function to display a short's prompt's date in the profile view.
    func convertDateString(intDateString: String) -> String {
        // Step 1: Create a DateFormatter for the input format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMdd"
        
        // Step 2: Convert the input string to a Date object
        guard let date = inputFormatter.date(from: intDateString) else {
            return ""
        }
        
        // Step 3: Create a DateFormatter for the output format
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d"
        
        // Step 4: Format the date to the desired output string
        let formattedDate = outputFormatter.string(from: date)
        
        // Step 5: Add the ordinal suffix
        let day = Calendar.current.component(.day, from: date)
        let suffix: String
        switch day {
        case 11, 12, 13:
            suffix = "th"
        default:
            switch day % 10 {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default:
                suffix = "th"
            }
        }
        
        // Step 6: Append the suffix and year
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let year = yearFormatter.string(from: date)
        
        return "\(formattedDate)\(suffix), \(year)"
    }
    
    // Either sort the shorts by date or by likeCount
//    func sortShorts(byDateWritten: Bool, byNumLikes: Bool, byPromptDate: Bool) {
//        
//        // set the bool (controls view dropdown text)
//        
//        // clear the chunks
//        self.chunksOfShorts = []
//        // sort by date
//        if byDateWritten {
//            self.shortsSortingMethod = 0
//            // Sort by timestamp (converted to date)
//            self.shorts = self.shorts.sorted(by: {$0.rawTimestamp!.dateValue() > $1.rawTimestamp!.dateValue()} )
//        }
//        
//        // sort by like count
//        if byNumLikes {
//            self.shortsSortingMethod = 1
//            self.shorts = self.shorts.sorted(by: {$0.likeCount! > $1.likeCount! })
//        }
//        
//        // sort by prompt date
//        if byPromptDate {
//            self.shortsSortingMethod = 2
//            self.shorts = self.shorts.sorted(by: {$0.date! > $1.date! })
//        }
//        
//        // rebuild the chunks
//        let chunks = self.shorts.chunked(into: 3)
//        for chunk in chunks {
//            let arrayofShort = ArrayOfShort(shorts: chunk)
//            self.chunksOfShorts.append(arrayofShort)
//        }
//    }
    
    func submitPromptSuggestion(user: User) {
        if self.suggestedPromptText.isEmpty { return }
        
        Task {
            let promptSuggestion = PromptSuggestion(authorId: user.id!, authorFirstName: user.firstName!, authorLastName: user.lastName!, rawText: self.suggestedPromptText)
            
            do {
                try db.collection("promptSuggestions").addDocument(from: promptSuggestion)
                print("prompt suggestion written")
                
                DispatchQueue.main.async {
                    self.suggestedPromptText = ""
                }
            } catch let error {
                print("error uploading prompt suggestion: ", error.localizedDescription)
            }
        }
    }
    
    func clearShorts() {
        self.shorts = []
        self.chunksOfShorts = []
    }
    
    func deleteShort() {
        // Ensure user is authd
        if let user = Auth.auth().currentUser {
            // Ensure a short is focused
            if let short = self.focusedShort {
                // Remove the document from firestore
                Task {
                    do {
                        try await db.collection("shorts").document(short.id!).delete()
                        print("short successfully removed!")
                    } catch let error {
                        print("error deleting from firestore: ", error.localizedDescription)
                    }
                }
                
                // Update the user stats
                Task {
                    do {
                        let docRef = db.collection("users").document(user.uid)
                        docRef.updateData([
                            "shortsCount": FieldValue.increment(Int64(-1)),
                            "numLikes": FieldValue.increment(Int64(0 - (short.likeCount ?? 0)))
                        ])
                        print("updated stats for user")
                        
                        DispatchQueue.main.async {
                            // Clear the controller vars
                            self.focusedShort = nil
                            self.isFocusedShortSheetShowing = false
                        }
                    }
                }
            }
        }
    }
    
    func generateContributions(user: User) {
        self.contributions = []
        self.contributionCount = 0
        
        if let contributions = user.contributions {
            var dates: [String] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            
            let calendar = Calendar.current
            let today = Date()
            
            for i in 0..<88 {
                if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                    let dateString = dateFormatter.string(from: date)
                    dates.append(dateString)
                }
            }
            
            for date in dates {
                // cross check if the date has a write on it from the user
                if let didUserWrite = contributions[date] {
                    if didUserWrite {
                        self.contributions.append(Int(1))
                        self.contributionCount += 1
                    } else {
                        self.contributions.append(Int(0))
                    }
                } else {
                    self.contributions.append(Int(0))
                }
            }
        } else {
            print("no contributions?")
        }
    }
    
    func limitTextLengthSuggestedPrompt(_ upper: Int) {
        if self.suggestedPromptText.count > upper {
            self.suggestedPromptText = String(self.suggestedPromptText.prefix(upper))
        }
    }
    
    // limits the number of characters you can write when editing your short (2500 characters)
    func limitTextLength(_ upper: Int) {
        if self.newShortText.count > upper {
            self.newShortText = String(self.newShortText.prefix(upper))
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
    
    func getNextTitleCriteria(curLevel: Int, numShorts: Int) -> String {
        var totalShortsNeeded = 0
        switch curLevel {
        case 0:
            totalShortsNeeded = 1
        case 1:
            totalShortsNeeded = 5
        case 2:
            totalShortsNeeded = 10
        case 3:
            totalShortsNeeded = 25
        case 4:
            totalShortsNeeded = 50
        case 5:
            totalShortsNeeded = 100
        case 6:
            totalShortsNeeded = 200
        case 7:
            totalShortsNeeded = 300
        default:
            return ""
        }
        
        return "\(numShorts) / \(totalShortsNeeded) Shorts Written"
    }
    
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
