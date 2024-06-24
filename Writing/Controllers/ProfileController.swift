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
import SwiftUI

class ProfileController : ObservableObject {
    
    @Published var shorts: [Short] = []
    // Used to display in rows of three in the view (grid)
    var chunksOfShorts: [ArrayOfShort] = []
    @Published var promptImages: [String : UIImage] = [:]
    
    @Published var focusedShort: Short?
    
    @Published var newShortText: String = ""
    let characterLimit = 2500
    
    // vars that control the view
    
    @Published var isSignUpViewShowing: Bool = false
    @Published var isSettingsShowing: Bool = false
    @Published var showSidebar: Bool = false
    @Published var areShortsSortedByDate: Bool = true
    @Published var isFocusedShortSheetShowing: Bool = false
    
    // Firebase
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init() {
        print("init profile controller")
        retrieveShorts()
    }
    
    // Retrieves shorts the user has written, to be displayed on their profile
    // TODO: implemnet infinite scroll / pagination
    func retrieveShorts() {
        self.shorts = []
        self.chunksOfShorts = []
        
        if let user = Auth.auth().currentUser {
            // Lookup firestore shorts collection that match userId
            Task {
                do {
                    let querySnapshot = try await db.collection("shorts").whereField("authorId", isEqualTo: user.uid).order(by: "rawTimestamp", descending: true).getDocuments()
                    
                    DispatchQueue.main.async {
                        if querySnapshot.isEmpty {
                            print("no shorts returned")
                            return
                        }
                        
                        for document in querySnapshot.documents {
                            if let short = try? document.data(as: Short.self) {
                                // add the short to the local array, and fetch it's prompt and picture
                                self.retrievePromptImage(date: short.date!)
                                print("profile - appended short to list")
                                
                                self.shorts.append(short)
                            }
                        }
                        // split the short array into chunks
                        let chunks = self.shorts.chunked(into: 3)
                        for chunk in chunks {
                            let arrayofShort = ArrayOfShort(shorts: chunk)
                            self.chunksOfShorts.append(arrayofShort)
                        }
                    }
                } catch let error {
                    print("error retrieving the user's shorts: ", error.localizedDescription)
                }
            }
        } else {
            print("no auth user yet.")
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
    func sortShorts(byDate: Bool) {
        // set the bool (controls view dropdown text)
        self.areShortsSortedByDate = byDate
        
        // clear the chunks
        self.chunksOfShorts = []
        // sort by date
        if byDate {
            // Sort by timestamp (converted to date)
            self.shorts = self.shorts.sorted(by: {$0.rawTimestamp!.dateValue() > $1.rawTimestamp!.dateValue()} )
        } else {
            // sort by like count
            self.shorts = self.shorts.sorted(by: {$0.likeCount! > $1.likeCount! })
        }
        
        // rebuild the chunks
        let chunks = self.shorts.chunked(into: 3)
        for chunk in chunks {
            let arrayofShort = ArrayOfShort(shorts: chunk)
            self.chunksOfShorts.append(arrayofShort)
        }
    }
    
    // limits the number of characters you can write when editing your short (2500 characters)
    func limitTextLength(_ upper: Int) {
        if self.newShortText.count > upper {
            self.newShortText = String(self.newShortText.prefix(upper))
        }
    }
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
