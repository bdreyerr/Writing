//
//  ShortAnalysis.swift
//  Writing
//
//  Created by Ben Dreyer on 7/13/24.
//

import FirebaseFirestore
import Foundation

struct ShortAnalysis : Codable {
    @DocumentID var id: String?
    
    // Short attatchment
    var shortId: String?
    var authorId: String?
    
    // Content Scores
    var proseScore: Double?
    var imageryScore: Double?
    var flowScore: Double?
    
    // Overall Score
    var score: Double?
    
    // Text Analysis
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case shortId
        case authorId
        case proseScore
        case imageryScore
        case flowScore
        case score
        case content
    }
}
