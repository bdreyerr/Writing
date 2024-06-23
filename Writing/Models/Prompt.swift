//
//  Prompt.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation

public struct Prompt : Codable {
    // dates
    
    // Formated Date e,g, "20240612"
    var date: String?
    
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
