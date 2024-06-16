//
//  Short.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation

struct Short {
    // Dates
    
    var date: String?
    // Figure out how supabase can do timestamp, this was a firebase thing in the past. We need this for sorting by recent
//    var rawTimestamp: Timestamp?
    
    // Author
    var authorId: String?
    var authorName: String?
    var authorProfilePictureUrl: String?
    
    // Content
    var shortRawText: String?
    var shortTitle: String? // Should I do titles?
    
    // Stats
    var likeCount: Int?
    var commentCount: Int?
}
