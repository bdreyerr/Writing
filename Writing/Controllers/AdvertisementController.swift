//
//  AdvertisementController.swift
//  Writing
//
//  Created by Ben Dreyer on 8/25/24.
//

import FirebaseFirestore
import Foundation
import FirebaseStorage
import UIKit


class AdvertisementController : ObservableObject {
    
    @Published var focusedAd: Ad?
    @Published var advertiserImage : UIImage?
    
    // Firestore
    let db = Firestore.firestore()
    
    // Storage
    let storage = Storage.storage()
    
    @Published var isFullAdSheetShowing: Bool = false
    
    
    // Ads in the Daily Short work via a daily system. There's one ad slot per day, available to be filled by a single advertiser.
    // If the advertiser signs up for an ad slot for a certain day, they are the only ad showing in the app that day.
    // We store ads in firestore, and if an document exists with the ID equal to the current date (e.g. 20240825) then we'll show
    // that ad to users.
    
    
    // vars that control the view
    @Published var isFocusedAdLiked: Bool = false
    
    init() {
        fetchAd()
    }
    
    
    // Lookup if an ad exists for the current date.
    func fetchAd() {
        // return early. Can only have 1 ad at a time.
        if let _ = self.focusedAd {
            return
        }
        
        
        // Get current date in YYYYMMDD format.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let currentDate = dateFormatter.string(from: Date())
        print(currentDate)
        
        Task {
            let docRef = db.collection("ads").document(currentDate)
            do {
                let fetchedAd = try await docRef.getDocument(as: Ad.self)
                
                DispatchQueue.main.async {
                    self.focusedAd = fetchedAd
                }
                
                // Fetch the advertiser image
                let imageRef = self.storage.reference().child("advertisers/" + (fetchedAd.advertiserPictureUrl ?? "") + ".jpeg")
                
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("error downloading image from storage: ", error.localizedDescription)
                        return
                    } else {
                        let image = UIImage(data: data!)
                        DispatchQueue.main.async {
                            self.advertiserImage = image
                        }
                    }
                }
            } catch {
                print("error decoding ad, or it wasn't found: ", error.localizedDescription)
                DispatchQueue.main.async {
                    self.focusedAd = nil
                    self.advertiserImage = nil
                }
            }
        }
    }
    
}
