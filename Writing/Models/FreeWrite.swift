//
//  FreeWrite.swift
//  Writing
//
//  Created by Ben Dreyer on 6/29/24.
//

import FirebaseFirestore
import Foundation

struct FreeWrite : Codable, Identifiable {
    @DocumentID var id: String?
    
    // Timestamp
    var rawTimestamp: Timestamp?
    
    // Author
    var authorId: String?
    
    // Content
    var title: String?
    var symbol: String?
    var content: String?
    var wordCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case rawTimestamp
        case authorId
        case title
        case symbol
        case content
        case wordCount
    }
}
