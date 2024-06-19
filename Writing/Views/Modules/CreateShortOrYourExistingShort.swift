//
//  CreateShortOrYourExistingShort.swift
//  Writing
//
//  Created by Ben Dreyer on 6/18/24.
//

import SwiftUI

struct CreateShortOrYourExistingShort: View {
    @EnvironmentObject var homeController: HomeController
    // TODO: put the userController here and pass in info that way about the author
    
    var body: some View {
        VStack {
            // If the users short is not nil in the home Controller, we should show the short. If it is nil, we should show a button that lets the user create their short
            
            if let short = homeController.usersFocusedShort {
                // Show the short if it exists
                Text("Your Response")
                    .font(.system(size: 16, design: .serif))
                    .bold()
                // Image name hardcoded for now
                SingleLimitedCommunityResponse(imageName: "wolf", authorHandle: short.authorFirstName!, timePosted: short.rawTimestamp!.dateValue().formatted(date: .omitted, time: .shortened), responseLimited: short.shortRawText!, numLikes: short.likeCount!, numComments: short.commentCount!)
            } else {
                // Else have the button
                NavigationLink(destination: CreateResponseView()) {
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(lineWidth: 1)
                        .frame(width: 200, height: 40)
                        .overlay {
                            HStack {
                                // TODO(bendreyer): have a couple different openers here (start your creation, dive right in, etc..) and pick one at random
                                Text("Once upon a time...")
                                    .font(.system(size: 14, design: .serif))
                                    .bold()
                                
                                Image(systemName: "plus.circle")
                                
                            }
                        }
                        .padding(.bottom, 10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            
        }
    }
    //    }
}

#Preview {
    CreateShortOrYourExistingShort()
        .environmentObject(HomeController())
}
