//
//  SingleLimitedCommunityResponse.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import FirebaseFirestore
import SwiftUI

struct SingleLimitedCommunityResponse: View {
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    
    // The short to be displayed (limied means preview, only show like first 200 characters of response)
    var short: Short
    // If the short belongs to the user, else it's a community short.
    var isOwnedShort: Bool
    
    var body: some View {
        Button(action: {
            homeController.focusSingleShort(short: self.short, isOwned: isOwnedShort)
            homeController.isFullCommunityResposneSheetShowing = true
        }) {
            VStack {
                HStack {
                    // Profile Picture
                    if isOwnedShort {
                        if let image = userController.usersProfilePicture {
                            Image(uiImage: image)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 40, height: 40)
                        } else {
                            Image("not-signed-in-profile")
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 40, height: 40)
                        }
                    } else {
                        if let image = homeController.communityProfilePictures[short.authorId!] {
                            Image(uiImage: image)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 40, height: 40)
                        } else {
                            Image("not-signed-in-profile")
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    
                    
                    VStack {
                        // Handle
                        Text(short.authorFirstName! + " " + short.authorLastName!)
                            .font(.system(size: 12, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            // Author title
                            Text(homeController.convertTitleIntToString(int: short.authorTitle ?? 0))
                                .font(.system(size: 10, design: .serif))
                                .opacity(0.6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                }
                
                // Response
                Text(short.shortRawText!.prefix(200))
                    .font(.system(size: 13, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    
                    ZStack {
                        HStack {
                            // like image
                            Image(systemName: "hand.thumbsup")
                                .resizable()
                                .frame(width: 15, height: 15)
                            // like number
                            Text("\(short.likeCount!.formatted())")
                                .font(.system(size: 13, design: .serif))
                        }
                        if let user = userController.user {
                            if let likesShorts = user.likedShorts {
                                if let isLike = likesShorts[self.short.id!] {
                                    if isLike {
                                        HStack {
                                            Image(systemName: "hand.thumbsup")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                            Text("\(short.likeCount!.formatted())")
                                                .font(.system(size: 13, design: .serif))
                                        }
                                        .foregroundStyle(Color.orange)
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        // Comment image
                        Image(systemName: "message")
                            .resizable()
                            .frame(width: 15, height: 15)
                        // comment number
                        Text("\(short.commentCount!.formatted())")
                            .font(.system(size: 13, design: .serif))
                    }
                    
                    // Report Short
                    Image(systemName: "info.circle")
                        .font(.caption)
                    
                    if let isNSFW = short.isNSFW {
                        if isNSFW {
                            Text("NSFW")
                                .font(.system(size: 10, design: .serif))
                                .foregroundStyle(Color.red)
                                .opacity(0.6)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SingleLimitedCommunityResponse(short: Short(date: "20240620", rawTimestamp: Timestamp(), authorId: "123", authorFirstName: "Ben", authorLastName: "Dreyer", authorProfilePictureUrl: "123", authorNumShorts: 12, authorNumLikes: 144, shortRawText: "This is a response for a good prompt and it was a great prompt to be honest so yearh.", likeCount: 4, commentCount: 1), isOwnedShort: false)
        .environmentObject(HomeController())
        .environmentObject(UserController())
}
