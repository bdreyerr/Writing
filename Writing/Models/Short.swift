//
//  Short.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Short : Codable, Identifiable {
    @DocumentID var id: String?
//    var id: String?
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
    var authorTitle: Int?
    
    // Content
    var promptRawText: String?
    var shortRawText: String?
    var isNSFW: Bool?
    
    // Stats
    var likeCount: Int?
    var commentCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case rawTimestamp
        case authorId
        case authorFirstName
        case authorLastName
        case authorProfilePictureUrl
        case authorNumShorts
        case authorNumLikes
        case authorTitle
        case promptRawText
        case shortRawText
        case isNSFW
        case likeCount
        case commentCount
    }
}

struct ArrayOfShort : Identifiable {
    let id = UUID()
    var shorts = [Short]()
}
