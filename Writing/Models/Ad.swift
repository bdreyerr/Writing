//
//  Ad.swift
//  Writing
//
//  Created by Ben Dreyer on 8/25/24.
//

import Foundation
import FirebaseFirestore

struct Ad : Codable {
    var date: String?
    
    // Advertiser Information
    var advertiserName: String?
    var advertiserSubtitle: String?
    var advertiserPictureUrl: String?
    
    // Ad Content
    var contentPreview: String?
    var contentFull: String?
    var redirectUrl: String?
    
    // stats
    var likeCount: Int?
    var commentCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case date
        case advertiserName
        case advertiserSubtitle
        case advertiserPictureUrl
        case contentPreview
        case contentFull
        case redirectUrl
        case likeCount
        case commentCount
    }
}
