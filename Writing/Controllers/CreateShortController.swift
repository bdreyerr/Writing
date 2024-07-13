//
//  CreateShortController.swift
//  Writing
//
//  Created by Ben Dreyer on 6/18/24.
//

import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

class CreateShortController : ObservableObject {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    // State
    @Published var shortContent: String = ""
    let characterLimit = 2500
    
    // Firebase
    let db = Firestore.firestore()
    
    func submitShort(user: User, prompt: Prompt) {
        // Make sure the user is signed in first (arg passed from AppStorage var)
        if !self.isSignedIn {
            print("User not signed in, cannot create a short")
            return
        }
        print("user is signed in we are good to go")
        
        // Create a new short
        let short = Short(date: prompt.date, rawTimestamp: Timestamp(date: Date()), authorId: user.id, authorFirstName: user.firstName, authorLastName: user.lastName, authorProfilePictureUrl: user.profilePictureUrl, authorNumShorts: user.shortsCount, authorNumLikes: user.numLikes, authorTitle: user.title ?? "", promptRawText: prompt.promptRawText!, shortRawText: self.shortContent, likeCount: 0, commentCount: 0)
        
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
            
            // Update the user's stats
            do {
                var addToStreak = false
                // Check if the currentStreak is active
                if isYesterdayOrToday(date: user.lastShortWrittenDate!.dateValue()) {
                    // Switch the bool meaning we should increment the value, not reset it
                    addToStreak = true
                }
                
                // value to add to bestStreak
                var bestStreak = 0
                if user.currentStreak == user.bestStreak && addToStreak {
                    bestStreak = 1
                }
                
                let userRef = db.collection("users").document(user.id!)
                try await userRef.updateData([
                    "shortsCount": FieldValue.increment(Int64(1)),
                    "currentStreak": addToStreak ? FieldValue.increment(Int64(1)) : 1,
                    "bestStreak": FieldValue.increment(Int64(bestStreak)),
                    "lastShortWrittenDate": Timestamp()
                ])
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return
    }
    
    // this function is called whenever a new character is added to the text field. Making sure it doesn't exceed the text length.
    func limitTextLength(_ upper: Int) {
        if self.shortContent.count > upper {
            self.shortContent = String(self.shortContent.prefix(upper))
        }
    }
    
    func isYesterdayOrToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDateInToday(date) || calendar.isDateInYesterday(date)
    }
}
