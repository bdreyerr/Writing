//
//  PromptSuggestion.swift
//  Writing
//
//  Created by Ben Dreyer on 6/28/24.
//

import Foundation

struct PromptSuggestion : Codable {
    var authorId: String?
    var authorFirstName: String?
    var authorLastName: String?
    var rawText: String?
    
    enum CodingKeys: String, CodingKey {
        case authorId
        case authorFirstName
        case authorLastName
        case rawText
    }
}
