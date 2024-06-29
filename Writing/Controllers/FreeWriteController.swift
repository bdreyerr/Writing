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
    
    @Published var freeWrites: [FreeWrite] = []
    @Published var focusedFreeWrite: FreeWrite?
    
    // Vars for creating a new free write
    @Published var titleText: String = ""
    @Published var iconName: String = "sun.max"
    @Published var contentText: String = ""
    @Published var wordCount: Int = 0
    
    // Vars controlling view
    @Published var isSingleFreeWriteSheetShowing: Bool = false
    
    // Icon collection (for choosing symbol on your entry)
    var iconOptions = ["message.fill", "phone.down.fill", "sun.max", "cloud.bolt.rain", "figure.walk.circle", "car", "paperplane.fill", "studentdesk", "display.2", "candybarphone", "photo.fill", "arrow.triangle.2.circlepath", "flag.checkered", "gamecontroller", "network.badge.shield.half.filled", "dot.radiowaves.left.and.right", "airplane.circle.fill", "bicycle", "snowflake.circle", "key.fill", "person.fill", "person.3", "house.fill", "party.popper.fill", "figure.archery", "sportscourt.fill", "globe.americas.fill", "sun.snow", "moon.fill", "wind.snow", "bolt.square.fill", "wand.and.stars.inverse", "bandage.fill", "textformat.abc", "play.rectangle.fill", "shuffle", "command.circle.fill", "keyboard.fill", "cart.fill", "giftcard.fill", "pesosign.circle", "chineseyuanrenminbisign.circle.fill", "hourglass.circle.fill", "heart.fill", "pill.fill", "eye", "brain.fill", "percent"]
    
    // Firestore
    let db = Firestore.firestore()
    
    init() {
        self.retrieveFreeWrites()
    }
    
    // TODO: Implement infinite scroll
    func retrieveFreeWrites() {
        self.freeWrites = []
        
        // Ensure the user is authenticated
        if let user = Auth.auth().currentUser {
            // Start async task to read FreeWrites for user from firestore
            Task {
                do {
                    let querySnapshot = try await db.collection("freeWrites").whereField("authorId", isEqualTo: user.uid).order(by: "rawTimestamp", descending: true).limit(to: 6).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no shorts returned")
                            return
                        }
                        
                        for document in querySnapshot.documents {
                            if let freeWrite = try? document.data(as: FreeWrite.self) {
                                self.freeWrites.append(freeWrite)
                            }
                        }
                    }
                } catch let error {
                    print("error getting free writes from firestore")
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
            
            // Ensure title text and content text are not empty
            if titleText.isEmpty || contentText.isEmpty { return }
            
            let freeWrite = FreeWrite(rawTimestamp: Timestamp(), authorId: user.uid, title: self.titleText, symbol: self.iconName, content: self.contentText, wordCount: wordCount)
            Task {
                // Write the Free Write to Firestore
                do {
                    try db.collection("freeWrites").addDocument(from: freeWrite)
                    print("free write written to firestore")
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
                    print("updated stats for user")
                    
                    // Reset view vars
                    DispatchQueue.main.async {
                        self.titleText = ""
                        self.iconName = "sun.max"
                        self.contentText  = ""
                        self.wordCount = 0
                    }
                } catch let error {
                    print("error updating free write stats for the user in firestore: ", error.localizedDescription)
                }
            }
        }
    }
    
    func updateWordCount() {
        let words = self.contentText.split { !$0.isLetter }
        self.wordCount = words.count
    }
}
