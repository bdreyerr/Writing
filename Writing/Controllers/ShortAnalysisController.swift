//
//  ShortAnalysisController.swift
//  Writing
//
//  Created by Ben Dreyer on 7/13/24.
//

import FirebaseFirestore
import Foundation
import OpenAI
import SwiftUI

// The class which controlls the AI analysis for shorts
class ShortAnalysisController : ObservableObject {
    
    @Published var focusedShortAnalysis: ShortAnalysis?
    // cached analysis'
    var cachedShortAnalysis: [String : ShortAnalysis] = [:]
    
    
    // vars controlling the view
    @Published var isLoadingAnalysis: Bool = false
    @Published var isErrorLoadingAnalysis: Bool = false
    @Published var isAnalysisHelpPopoverShowing: Bool = false
    @Published var isConfirmCreateAnalysisAlertShowing: Bool = false
    
    
    // OpenAI Config
    let openAI = OpenAI(configuration: OpenAI.Configuration(token: Secrets().openAIKey, timeoutInterval: 60.0))
    
    // Firestore
    let db = Firestore.firestore()
    
    init() {
//        self.isLoadingAnalysis = true
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
//                        print("no shorts returned, setting loading to false")
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
    func createAnalysis(user: User, short: Short) {
        // Create a ShortAnalysis object and write it into firestore.
        self.isLoadingAnalysis = true
        
        Task {
            // Get writing scores
            do {
                let writingScores = try await getWritingScores(short: short)
                
//                print("writing score is: ", writingScores)
                let proseScore = writingScores[0]
                let imageryScore = writingScores[1]
                let flowScore = writingScores[2]
                
                do {
                    let textAnalysis = try await getTextAnalysis(short: short)
                    
                    // Create overall score (average the 3)
                    let overallScore = (proseScore + imageryScore + flowScore) / 3.0
                    
                    // Create the model object
                    let shortAnalysis = ShortAnalysis(shortId: short.id!, authorId: user.id!, proseScore: proseScore, imageryScore: imageryScore, flowScore: flowScore, score: overallScore, content: textAnalysis)
                    
                    // Write the Free Write to Firestore
                    do {
                        try db.collection("shortAnalysis").addDocument(from: shortAnalysis)
//                        print("short analysis written to firestore")
                        
                        
                        // Get the new writing average for the user
                        // cur_average passed as arg
                        let curAvg = Double(user.avgWritingScore!)
                        // num analysis passed as arg
                        let numAnalysis = Double(user.numAnalysisGenerated!)
                        
                        let newAvg = ((curAvg * numAnalysis) + overallScore) / (numAnalysis + 1)
                        
                        // Write new writing avg to the user's page.
                        do {
                            let userRef = db.collection("users").document(user.id!)
                            try await userRef.updateData([
                                "avgWritingScore": newAvg,
                                "numAnalysisGenerated": (numAnalysis+1)
                            ])
                            
                            // Update View Controller variables
                            DispatchQueue.main.async {
                                self.isLoadingAnalysis = false
                                
                                // focus the newly created analysis
                                self.focusedShortAnalysis = shortAnalysis
                                // add it to the cache too
                                self.cachedShortAnalysis[short.id!] = shortAnalysis
                            }
                        } catch let error {
                            print("error updating user stats: ", error.localizedDescription)
                            isErrorLoadingAnalysis = true
                        }
                    } catch let error {
                        print("error writing new short analysis to firestore: ", error.localizedDescription)
                        isErrorLoadingAnalysis = true
                    }
                } catch {
                    print("error getting text analysis: ", error.localizedDescription)
                    isErrorLoadingAnalysis = true
                }
                
            } catch {
                print("error getting writing scores: ", error.localizedDescription)
                isErrorLoadingAnalysis = true
            }
        }
    }
    
    func getWritingScores(short: Short) async throws -> [Double] {
        let openAIPrompt = "Give me three scores out of 10 (example: 8.5) for the following piece of writing based on its prose, imagery and flow respectively. Only respond with the numbers separated by a space, with no period: \n \(short.shortRawText!)"
        
        let query = ChatQuery(messages: [.init(role: .user, content: openAIPrompt)!], model: .gpt4_o_mini, maxTokens: 10)
        do {
            let result = try await openAI.chats(query: query)
            let content = result.choices.first?.message.content?.string
            
            // Split the string by comma, then convert to double
            
//            print("the string we get from openAI: ", content!)
            let splitArray = content!.components(separatedBy: " ")
            let doubleArray = splitArray.compactMap { Double($0) }
//            print("the array we made:", doubleArray)
            
            if doubleArray.count != 3 {
                print("error getting three values for writing score")
                return [0,0,0]
            }
            
            return doubleArray
        } catch {
            print("error getting the AI writing scores: ", error.localizedDescription)
            return [0,0,0]
        }
    }
    
    // AI function
    func getTextAnalysis(short: Short) async throws -> String {
        let queryToAPI = "Write an analysis for the following piece of writing in 150 words or less explaining what the writer did well and what could be better: \n \(short.shortRawText!)"
        
        let query = ChatQuery(messages: [.init(role: .user, content: queryToAPI)!], model: .gpt4_o_mini, maxTokens: 400)
        
        do {
            let result = try await openAI.chats(query: query)
            let content = result.choices.first?.message.content?.string
//            print("content of text analysis AI query: ", content!)
            return content ?? ""
        } catch {
            print("error doing AI for imagery score")
            return ""
        }
    }
    
    
    func determineScoreColor(score: Double) -> Color {
        switch score {
        case 0.00..<3.33:
            return Color.red
        case 3.33..<6.66:
            return Color.orange
        case 6.66...10.0:
            return Color.green
        default:
            return Color.green
        }
    }
    
    // re-do analysis
}
