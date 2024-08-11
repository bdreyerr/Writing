//
//  FreeWriteController.swift
//  Writing
//
//  Created by Ben Dreyer on 6/29/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class FreeWriteController : ObservableObject {
    
    
    // Free Writes (sorted by date descending)
    @Published var freeWrites: [FreeWrite] = []
    
    // Free writes (sorted by date ascending)
    @Published var freeWritesOldest: [FreeWrite] = []
    
    // The focused freeWrite (user tapped on it)
    @Published var focusedFreeWrite: FreeWrite?
    
    // sorting method (0 = newest, 1 = oldest)
    @Published var selectedSortingMethod: Int = 0
    
    // Vars for creating a new free write
    @Published var titleText: String = ""
    @Published var iconName: String = "sun.max"
    @Published var contentText: String = ""
    @Published var wordCount: Int = 0
    
    // Pagination
    @Published var lastDoc: QueryDocumentSnapshot?
    
    // Pagination - sort by oldest
    @Published var lastDocOldest: QueryDocumentSnapshot?
    
    // Vars controlling view
    @Published var isCreateEntrySheetShowing: Bool = false
    @Published var isSingleFreeWriteSheetShowing: Bool = false
    @Published var isConfirmDeleteAlertShowing: Bool = false
    @Published var areNoShortsLeftToLoad: Bool = false
    
    // Icon collection (for choosing symbol on your entry)
    var iconOptions = ["message.fill", "phone.down.fill", "sun.max", "cloud.bolt.rain", "figure.walk.circle", "car", "paperplane.fill", "studentdesk", "display.2", "candybarphone", "photo.fill", "arrow.triangle.2.circlepath", "flag.checkered", "gamecontroller", "network.badge.shield.half.filled", "dot.radiowaves.left.and.right", "airplane.circle.fill", "bicycle", "snowflake.circle", "key.fill", "person.fill", "person.3", "house.fill", "party.popper.fill", "figure.archery", "sportscourt.fill", "globe.americas.fill", "sun.snow", "moon.fill", "wind.snow", "bolt.square.fill", "wand.and.stars.inverse", "bandage.fill", "textformat.abc", "play.rectangle.fill", "shuffle", "command.circle.fill", "keyboard.fill", "cart.fill", "giftcard.fill", "pesosign.circle", "chineseyuanrenminbisign.circle.fill", "hourglass.circle.fill", "heart.fill", "pill.fill", "eye", "brain.fill", "percent"]
    
    // Firestore
    let db = Firestore.firestore()
    
    init() {
        self.retrieveFreeWrites()
    }
    
    func switchSortingMethod() {
        self.areNoShortsLeftToLoad = false
        
        // if no shorts are in the respective list, retrieve the initial one
        if selectedSortingMethod == 0 {
            if freeWrites.isEmpty {
                retrieveFreeWrites()
            }
        } else {
            if freeWritesOldest.isEmpty {
                retrieveFreeWrites()
            }
        }
    }
    
    
    func retrieveFreeWrites() {
        if selectedSortingMethod == 0 {
            self.freeWrites = []
        } else {
            self.freeWritesOldest = []
        }
        
        
        // Ensure the user is authenticated
        if let user = Auth.auth().currentUser {
            // Start async task to read FreeWrites for user from firestore
            Task {
                do {
                    let querySnapshot = try await db.collection("freeWrites").whereField("authorId", isEqualTo: user.uid).order(by: "rawTimestamp", descending: selectedSortingMethod == 0 ? true : false).limit(to: 8).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no shorts returned")
                            self.areNoShortsLeftToLoad = true
                            return
                        }
                        
                        for document in querySnapshot.documents {
                            if let freeWrite = try? document.data(as: FreeWrite.self) {
                                if self.selectedSortingMethod == 0 {
                                    self.freeWrites.append(freeWrite)
                                } else {
                                    self.freeWritesOldest.append(freeWrite)
                                }
                            }
                        }
                        
                        // get the last doc (for pagination)
                        guard let lastSnapshot = querySnapshot.documents.last else {
                            // The collection is empty.
//                            print("error getting the last document snapshot")
                            return
                        }
                        
                        if self.selectedSortingMethod == 0 {
                            self.lastDoc = lastSnapshot
                        } else {
                            self.lastDocOldest = lastSnapshot
                        }
                    }
                } catch let error {
                    print("error getting free writes from firestore: ", error.localizedDescription)
                }
            }
        }
    }
    
    func retrieveNextFreeWrites() {
        // Ensure the user is authenticated
        if let user = Auth.auth().currentUser {
            Task {
                do {
                    
                    let querySnapshot = try await db.collection("freeWrites").whereField("authorId", isEqualTo: user.uid).order(by: "rawTimestamp", descending: selectedSortingMethod == 0 ? true : false).limit(to: 6).start(afterDocument: selectedSortingMethod == 0 ? self.lastDoc! : self.lastDocOldest!).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no shorts returned")
                            self.areNoShortsLeftToLoad = true
                            return
                        }
                        
                        for document in querySnapshot.documents {
                            if let freeWrite = try? document.data(as: FreeWrite.self) {
                                if self.selectedSortingMethod == 0 {
                                    self.freeWrites.append(freeWrite)
                                } else {
                                    self.freeWritesOldest.append(freeWrite)
                                }
                            }
                        }
                        
                        // get the last doc (for pagination)
                        guard let lastSnapshot = querySnapshot.documents.last else {
                            // The collection is empty.
//                            print("error getting the last document snapshot")
                            return
                        }
                        
                        
                        if self.selectedSortingMethod == 0 {
                            self.lastDoc = lastSnapshot
                        } else {
                            self.lastDocOldest = lastSnapshot
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func focusFreeWrite(freeWrite: FreeWrite) {
        self.focusedFreeWrite = nil
        self.focusedFreeWrite = freeWrite
    }
    
    func submitFreeWrite(freeWriteCount: Int, freeWriteAverageWordCount: Int) {
        // Ensure the user is authenticated
        if let user = Auth.auth().currentUser {
            self.areNoShortsLeftToLoad = false
            
            // Ensure title text and content text are not empty
            if titleText.isEmpty || contentText.isEmpty { return }
            
            let freeWrite = FreeWrite(rawTimestamp: Timestamp(), authorId: user.uid, title: self.titleText, symbol: self.iconName, content: self.contentText, wordCount: wordCount)
            Task {
                // Write the Free Write to Firestore
                do {
                    try db.collection("freeWrites").addDocument(from: freeWrite)
//                    print("free write written to firestore")
                } catch let error {
                    print("error writing new free write to firestore: ", error.localizedDescription)
                }
                
                // Update the user in firestore (free write count and average word count)
                do {
                    // Find new word count average
                    let newWordCountAverage = ((freeWriteAverageWordCount * freeWriteCount) + self.wordCount) / (freeWriteCount + 1)
                    
                    
                    let docRef = db.collection("users").document(user.uid)
                    docRef.updateData([
                        "freeWriteCount": FieldValue.increment(Int64(1)),
                        "freeWriteAverageWordCount": newWordCountAverage
                    ])
//                    print("updated stats for user")
                    
                    // Reset view vars
                    DispatchQueue.main.async {
                        self.titleText = ""
                        self.iconName = "sun.max"
                        self.contentText  = ""
                        self.wordCount = 0
                    }
                }
            }
            
            Task {
                // Update the user's stats
                
                // Get today's date in YYYYMMDD
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                
                let today = Date()
                let formattedDate = dateFormatter.string(from: today)
                
                do {
                    let userRef = db.collection("users").document(user.uid)
                    try await userRef.updateData([
                        "contributions.\(formattedDate)": true
                    ])
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func editFreeWrite(freeWriteCount: Int, freeWriteOldAverageWordCount: Int) {
        // Ensure user is authd
        if let user = Auth.auth().currentUser {
            // Check if title and content is empty
            if self.titleText.isEmpty || self.contentText.isEmpty { return }
            
            
            if let oldFreeWrite = self.focusedFreeWrite {
                // Check if title and content and symbol are unchanged
                if self.titleText == oldFreeWrite.title! && self.contentText == oldFreeWrite.content! && self.iconName == oldFreeWrite.symbol! { return }
                
                Task {
                    // Edit the free Write document
                    db.collection("freeWrites").document(oldFreeWrite.id!).updateData([
                        "title": self.titleText,
                        "symbol": self.iconName,
                        "content": self.contentText,
                        "wordCount": self.wordCount
                    ])
//                    print("free write updated in firestore")
                    
                    // Edit the user's average word count
                    
                    // n = number of documents (freeWriteCount)
                    // W = The average word count before editing (freeWriteOldAverageWordCount)
                    
                    // word count of the document before editing
                    let wordCountBeforeEditing = oldFreeWrite.wordCount!
                    
                    // word count of the document after editing
                    let wordCountAfterEditing = self.wordCount
                    
                    // New Average word count = W - (Wold / n) + (Wnew / n)
                    let newAverageWordCount = freeWriteOldAverageWordCount - (wordCountBeforeEditing / freeWriteCount) + (wordCountAfterEditing / freeWriteCount)
                    
//                    print("word count for the old one: ", wordCountBeforeEditing)
//                    print("word count for the new one: ", wordCountAfterEditing)
                    do {
                        let docRef = db.collection("users").document(user.uid)
                        docRef.updateData([
                            "freeWriteAverageWordCount": newAverageWordCount
                        ])
//                        print("updated stats for user")
                        
                        DispatchQueue.main.async {
                            self.titleText = ""
                            self.iconName = "sun.max"
                            self.contentText  = ""
                            self.wordCount = 0
                            self.isSingleFreeWriteSheetShowing = false
                        }
                    }
                }
            }
        }
    }
    
    func deleteFreeWrite(freeWriteCount: Int, averageWordCountBeforeDeletion: Int) {
        // Ensure user is authd
        if let user = Auth.auth().currentUser {
            // Ensure a freeWrite is focused
            if let freeWrite = self.focusedFreeWrite {
                // Remove the document from firestore
                Task {
                    do {
                        try await db.collection("freeWrites").document(freeWrite.id!).delete()
//                        print("free write successfully removed!")
                    } catch let error {
                        print("error deleting from firestore: ", error.localizedDescription)
                    }
                }
                
                // Update users stats
                Task {
                    // W = averageWordCountBeforeDeletion
                    let W = averageWordCountBeforeDeletion
                    
                    // n = total number of documents before deletion
                    let n = freeWriteCount
                    
                    // Wdelete = the word count of the document being deleted
                    let Wdelete = freeWrite.wordCount!
                    
                    // Wnew = new average word count after deletion
                    
                    // Wnew = ((n * W) - Wdelete) / n-1
                    let Wnew = ((n * W) - Wdelete) / (n - 1)
                    
                    // Update the users stats
                    do {
                        let docRef = db.collection("users").document(user.uid)
                        docRef.updateData([
                            "freeWriteCount": FieldValue.increment(Int64(-1)),
                            "freeWriteAverageWordCount": Wnew
                        ])
//                        print("updated stats for user")
                        
                        DispatchQueue.main.async {
                            // Clear the controller vars
                            self.titleText = ""
                            self.iconName = "sun.max"
                            self.contentText  = ""
                            self.wordCount = 0
                            self.focusedFreeWrite = nil
                            self.isSingleFreeWriteSheetShowing = false
                        }
                    }
                }
            }
        }
    }
    
    // updates the word count of a new entry being created or an entry being edited.
    func updateWordCount() {
        let words = self.contentText.split { !$0.isLetter }
        self.wordCount = words.count
    }
}


