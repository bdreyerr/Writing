//
//  ShortComment.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation

struct ShortComment {
    // Dates
    var date: String?
    var time: String?
    // rawtimestamp
    
    // Parent - the Id of the short this comment is on
    var parentShort: String?
    
    // Author
    var commentAuthorId: String?
    var commentAuthorName: String?
    var commentAuthorProfilePictureUrl: String?
    
    // Content
    var commentRawText: String?
}
