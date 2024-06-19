//
//  Prompt.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation

public struct Prompt : Codable {
    // dates
    
    // Formated Date e,g, "Jun 1, 2024"
    var date: String?
    // Figure out how supabase can do timestamp, this was a firebase thing in the past. We need this for sorting by recent
//    var rawTimestamp: Timestamp?
    
    // Prompt Content
    var promptRawText: String?
    var promptImageUrl: String?
    
    // Prompt Stats
    var likeCount: Int?
    var shortCount: Int?
    var tags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case date
        case promptRawText
        case promptImageUrl
        case likeCount
        case shortCount
        case tags
    }
}
