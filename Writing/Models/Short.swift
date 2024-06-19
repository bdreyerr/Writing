//
//  Short.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation
import FirebaseFirestore

struct Short : Codable {
    // Date -- also the firestore Id of the prompt this short was written for.
    var date: String?
    // Exact time the short was submitted, used for sorting.
    var rawTimestamp: Timestamp?
    
    // Author
    var authorId: String?
    var authorFirstName: String?
    var authorLastName: String?
    var authorProfilePictureUrl: String?
    var authorNumShorts: Int?
    var authorNumLikes: Int?
    
    // Content
    var shortRawText: String?
    
    // Stats
    var likeCount: Int?
    var commentCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case date
        case rawTimestamp
        case authorId
        case authorFirstName
        case authorLastName
        case authorProfilePictureUrl
        case authorNumShorts
        case authorNumLikes
        case shortRawText
        case likeCount
        case commentCount
    }
}
