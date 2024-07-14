//
//  ShortAnalysisController.swift
//  Writing
//
//  Created by Ben Dreyer on 7/13/24.
//

import FirebaseFirestore
import Foundation

// The class which controlls the AI analysis for shorts
class ShortAnalysisController : ObservableObject {
    
    @Published var focusedShortAnalysis: ShortAnalysis?
    // cached analysis'
    var cachedShortAnalysis: [String : ShortAnalysis] = [:]
    
    
    // vars controlling the view
    @Published var isLoadingAnalysis: Bool = false
    @Published var isAnalysisHelpPopoverShowing: Bool = false
    @Published var isConfirmCreateAnalysisAlertShowing: Bool = false
    
    // Firestore
    let db = Firestore.firestore()
    
    init() {
        self.isLoadingAnalysis = true
    }
    
    // attempt to retrieve an analysis when you visit the corresponding view (may return nothing)
    func retrieveAnalysis(shortId: String) {
        // if the shortId is in the cache already, just focus it
        if let analysis = self.cachedShortAnalysis[shortId] {
            self.focusedShortAnalysis = analysis
            return
        }
        
        Task {
            do {
                let querySnapshot = try await db.collection("shortAnalysis").whereField("shortId", isEqualTo: shortId).getDocuments()
                
                DispatchQueue.main.async {
                    if querySnapshot.isEmpty {
                        print("no shorts returned, setting loading to false")
                        self.isLoadingAnalysis = false
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        if let analysis = try? document.data(as: ShortAnalysis.self) {
                            self.focusedShortAnalysis = analysis
                            self.cachedShortAnalysis[analysis.id!] = analysis
                            self.isLoadingAnalysis = false
                        }
                        // we can break, this query will only return one result
                        break
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // create analysis
    func createAnalysis(userId: String, short: Short) {
        // Create a ShortAnalysis object and write it into firestore.
        self.isLoadingAnalysis = true
        
        //TODO(): hookup the AI, for now it's just hardcoded
        let shortAnalysis = ShortAnalysis(shortId: short.id!, authorId: userId, proseScore: 7.6, imageryScore: 6.4, flowScore: 4.5, score: 5.6, content: "This is the hardcoded analysis. It will remain hardcoded until we hookup the AI.")
        
        Task {
            // Write the Free Write to Firestore
            do {
                try db.collection("shortAnalysis").addDocument(from: shortAnalysis)
                print("short analysis written to firestore")
                
                DispatchQueue.main.async {
                    self.isLoadingAnalysis = false
                    
                    // focus the newly created analysis
                    self.focusedShortAnalysis = shortAnalysis
                    // add it to the cache too
                    self.cachedShortAnalysis[short.id!] = shortAnalysis
                }
            } catch let error {
                print("error writing new short analysis to firestore: ", error.localizedDescription)
            }
        }
    }
    
    
    func determineScoreColor(score: Double) {
        //TODO(fill in)
    }
    
    // re-do analysis
}
