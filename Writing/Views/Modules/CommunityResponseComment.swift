//
//  CommunityResponseComment.swift
//  Writing
//
//  Created by Ben Dreyer on 6/4/24.
//

import FirebaseFirestore
import SwiftUI

struct CommunityResponseComment: View {
    @EnvironmentObject var homeController: HomeController
    
    var comment: ShortComment
    
    var body: some View {
        VStack {
            HStack {
                // Profile Picture
                if let image = homeController.communityProfilePictures[comment.authorId!] {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                } else {
                    Image("not-signed-in-profile")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                }
                
                VStack {
                    // Handle
                    Text(comment.authorFirstName! + " " + comment.authorLastName!)
                        .font(.system(size: 11, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Date posted
                    Text(comment.rawTimestamp!.dateValue().formatted(date: .abbreviated, time: .shortened))
                        .font(.system(size: 11, design: .serif))
                        .opacity(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Response
            Text(comment.commentRawText!)
                .font(.system(size: 12, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    CommunityResponseComment(comment: ShortComment(rawTimestamp: Timestamp(), authorFirstName: "Ben", authorLastName: "Dreyer", commentRawText: "This is a substantial story, it really has a lot of vigor. Well done."))
}
