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
    
    // if the create short sheet is showing
    @Published var isCreateShortSheetShowing = false
    
    // State
    @Published var shortContent: String = ""
    @Published var isNSFW: Bool = false
    
    let characterLimit = 2500
    
    // Firebase
    let db = Firestore.firestore()
    
    func submitShort(user: User, prompt: Prompt) {
        // Make sure the user is signed in first (arg passed from AppStorage var)
        if !self.isSignedIn {
//            print("User not signed in, cannot create a short")
            return
        }
//        print("user is signed in we are good to go")
        
        // Create a new short
        let short = Short(date: prompt.date, rawTimestamp: Timestamp(date: Date()), authorId: user.id, authorFirstName: user.firstName, authorLastName: user.lastName, authorProfilePictureUrl: user.profilePictureUrl, authorNumShorts: user.shortsCount, authorNumLikes: user.numLikes, authorTitle: user.title ?? 0, promptRawText: prompt.promptRawText!, shortRawText: self.shortContent, isNSFW: self.isNSFW, likeCount: 0, commentCount: 0)
        
        Task {
            // Write the short to firebase
            do {
                try db.collection("shorts").addDocument(from: short)
//                print("short written to firestore")
            } catch let error {
                print("error writign short to firestore: ", error.localizedDescription)
            }
        }
        
        Task {
            // Update the prompt response count
            do {
                let promptRef = db.collection("prompts").document(prompt.date!)
                try await promptRef.updateData([
                    "shortCount": FieldValue.increment(Int64(1))
                ])
//                print("shortCount updated +1")
            } catch let error {
                print("error updating short count on prompt: ", error.localizedDescription)
            }
        }
        
        Task {
            // Update the user's stats
            do {
                var amountToAddToCurrentStreak = -1
                
                if isYesterday(date: user.lastShortWrittenDate!.dateValue()) {
                    amountToAddToCurrentStreak = 1
                } else if isToday(date: user.lastShortWrittenDate!.dateValue()) {
                    amountToAddToCurrentStreak = 0
                }
                
                // value to add to bestStreak
                var bestStreak = 0
                if user.currentStreak == user.bestStreak && amountToAddToCurrentStreak == 1 {
                    bestStreak = 1
                }
                
                
                // TODO(): Have some sort of animation when a user unlocks a new title
                // check if the user reached a title milestone
                let curTitleLevel = user.title ?? 0
                let numShorts = user.shortsCount ?? 0
                let shouldIncrementTitleLevel = shouldIncrementTitleLevel(curTitleLevel: curTitleLevel, numShorts: numShorts)
                
                let userRef = db.collection("users").document(user.id!)
                try await userRef.updateData([
                    "shortsCount": FieldValue.increment(Int64(1)),
                    "title": shouldIncrementTitleLevel ? FieldValue.increment(Int64(1)) : FieldValue.increment(Int64(0)),
                    "currentStreak": amountToAddToCurrentStreak >= 0 ? FieldValue.increment(Int64(amountToAddToCurrentStreak)) : 1,
                    "bestStreak": FieldValue.increment(Int64(bestStreak)),
                    "lastShortWrittenDate": Timestamp(),
                    "contributions.\(prompt.date!)": true
                ])
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return
    }
    
    func shouldIncrementTitleLevel(curTitleLevel: Int, numShorts: Int) -> Bool {
        switch curTitleLevel {
        case 0:
            if numShorts == 0 {
                return true
            }
        case 1:
            if numShorts == 4 {
                return true
            }
        case 2:
            if numShorts == 9 {
                return true
            }
        case 3:
            if numShorts == 24 {
                return true
            }
        case 4:
            if numShorts == 49 {
                return true
            }
        case 5:
            if numShorts == 99 {
                return true
            }
        case 6:
            if numShorts == 199 {
                return true
            }
        default:
            return false
        }
        
        return false
    }
    
    // this function is called whenever a new character is added to the text field. Making sure it doesn't exceed the text length.
    func limitTextLength(_ upper: Int) {
        if self.shortContent.count > upper {
            self.shortContent = String(self.shortContent.prefix(upper))
        }
    }
    
    func isYesterday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
}
