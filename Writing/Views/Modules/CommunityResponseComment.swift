//
//  CommunityResponseComment.swift
//  Writing
//
//  Created by Ben Dreyer on 6/4/24.
//

import SwiftUI

struct CommunityResponseComment: View {
    
    var imageName: String
    var authorHandle: String
    var timePosted: String
    var comment: String
    
    var body: some View {
        VStack {
            HStack {
                // Profile Picture
                Image(imageName)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)
                
                VStack {
                    // Handle
                    Text(authorHandle)
                        .font(.system(size: 11, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Date posted
                    Text(timePosted)
                        .font(.system(size: 11, design: .serif))
                        .opacity(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Response
            Text(comment)
                .font(.system(size: 12, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    CommunityResponseComment(imageName: "space-guy", authorHandle: "southxx", timePosted: "7:45am", comment: "This is a substantial story, it really has a lot of vigor. Well done.")
}
