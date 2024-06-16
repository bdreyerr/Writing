//
//  Prompt.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation

struct Prompt {
    // dates
    
    // Formated Date e,g, "Jun 1, 2024"
    var date: String?
    // Figure out how supabase can do timestamp, this was a firebase thing in the past. We need this for sorting by recent
//    var rawTimestamp: Timestamp?
    
    // Prompt Content
    var promptRawText: String?
    var promptImageUrl: String?
    
    // Prompt Stats
    var likeCount: String?
    var shortCount: String?
    var tags: [String]?
}
