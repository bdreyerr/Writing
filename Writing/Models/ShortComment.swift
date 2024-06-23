//
//  ShortComment.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation
import FirebaseFirestore

struct ShortComment : Codable, Identifiable {
    @DocumentID var id: String?
    
    // Parent - the Id of the short this comment is on
    var parentShortId: String?
    
    // rawtimestamp
    var rawTimestamp: Timestamp?
    
    
    // Author
    var authorId: String?
    var authorFirstName: String?
    var authorLastName: String?
    var authorProfilePictureUrl: String?
    
    // Content
    var commentRawText: String?
    
    enum CodingKeys : String, CodingKey {
        case id
        case parentShortId
        case rawTimestamp
        case authorId
        case authorFirstName
        case authorLastName
        case authorProfilePictureUrl
        case commentRawText
    }
}
