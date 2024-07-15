//
//  User.swift
//  Writing
//
//  Created by Ben Dreyer on 6/12/24.
//

import FirebaseFirestore
import Foundation


struct User : Codable {
    @DocumentID var id: String?
    var firstName: String?
    var lastName: String?
    
    var email: String?
    // A url path to the storage bucket the file is stored in
    var profilePictureUrl: String?
    // A count of how many shorts this user has written
    var shortsCount: Int?
    var numLikes: Int?
    // The average score of the user's writings and the number of analysis been generated
    var avgWritingScore: Float?
    var numAnalysisGenerated: Int?
    
    // Title
    var title: Int?
    
    // Streaks
    var lastShortWrittenDate: Timestamp?
    var currentStreak: Int?
    var bestStreak: Int?
    
    // Free Write Info
    var freeWriteCount: Int?
    var freeWriteAverageWordCount: Int?
    
    var isAdmin: Bool?
    // Map of userIds : isBlocked
    var blockedUsers: [String: Bool]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case profilePictureUrl
        case shortsCount
        case numLikes
        case avgWritingScore
        case numAnalysisGenerated
        case title
        case lastShortWrittenDate
        case currentStreak
        case bestStreak
        case freeWriteCount
        case freeWriteAverageWordCount
        case isAdmin
        case blockedUsers
    }
}
