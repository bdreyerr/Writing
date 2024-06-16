//
//  User.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import Foundation


struct User : Encodable {
    // ID? IDK how supabase does it
    var firstName: String?
    var lastName: String?
    
    var email: String?
    // A url path to the storage bucket the file is stored in
    var profilePictureUrl: String?
    // A count of how many shorts this user has written
    var shortsCount: Int?
    var numLikes: Int?
    // The average score of the user's writings
    var avgWritingScore: Int?
    var isAdmin: Bool?
    // Map of userIds : isBlocked
    var blockedUsers: [String: Bool]?
}
