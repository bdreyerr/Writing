//
//  SingleLimitedCommunityResponse.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct SingleLimitedCommunityResponse: View {
    
    var imageName: String
    var authorHandle: String
    var timePosted: String
    var responseLimited: String
    var numLikes: Int
    var numComments: Int
    
    
    var body: some View {
        VStack {
            HStack {
                // Profile Picture
                Image(imageName)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                
                
                VStack {
                    // Handle
                    Text(authorHandle)
                        .font(.system(size: 12, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Date posted
                    Text(timePosted)
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
            
            // Response
            Text(responseLimited)
                .font(.system(size: 13, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                HStack {
                    // Comment image
                    Image(systemName: "hand.thumbsup")
                        .resizable()
                        .frame(width: 15, height: 15)
                    // comment number
                    Text("\(numLikes)")
                        .font(.system(size: 13, design: .serif))
                }
                
                HStack {
                    // Comment image
                    Image(systemName: "message")
                        .resizable()
                        .frame(width: 15, height: 15)
                    // comment number
                    Text("\(numComments)")
                        .font(.system(size: 13, design: .serif))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    SingleLimitedCommunityResponse(imageName: "wolf", authorHandle: "bob", timePosted: "1:41pm", responseLimited: "The big bear walked up the way and he was frolicking so nice and it was big and gay and throbbing wtf", numLikes: 14, numComments: 2)
}
