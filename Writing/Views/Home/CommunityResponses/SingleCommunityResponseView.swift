//
//  SingleCommunityResponseView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import FirebaseFirestore
import SwiftUI

// The full view of a single community response to a prompt.
struct SingleCommunityResponseView: View {
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        ZStack {
            if let short = homeController.focusedSingleShort {
                VStack {
                    ScrollView(showsIndicators: false) {
                        // Handle
                        Text(short.authorFirstName! + " " + short.authorLastName!)
                            .font(.system(size: 14, design: .serif))
                        
                        HStack {
                            
                            HStack {
                                // Image
                                if homeController.isFocusedShortOwned {
                                    if let image = userController.usersProfilePicture {
                                        Image(uiImage: image)
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: 40, height: 40)
                                    } else {
                                        Image("not-signed-in-profile")
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: 40, height: 40)
                                    }
                                } else {
                                    if let image = homeController.communityProfilePictures[short.authorId!] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: 40, height: 40)
                                    } else {
                                        Image("not-signed-in-profile")
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: 40, height: 40)
                                    }
                                }
                            }
                            .padding()
                            
                            VStack {
                                Text("\(short.authorNumShorts!)")
                                    .font(.system(size: 16, design: .serif))
                                    .foregroundStyle(Color.green)
                                
                                Text("Shorts")
                                    .font(.system(size: 12, design: .serif))
                                
                            }
                            
                            VStack {
                                Text("\(short.authorNumLikes!)")
                                    .font(.system(size: 16, design: .serif))
                                    .foregroundStyle(Color.blue)
                                
                                Text("Likes")
                                    .font(.system(size: 12, design: .serif))
                                
                            }
                            
                        }
                        
                        // Prompt
                        if let prompt = homeController.focusedPrompt {
                            Text(prompt.promptRawText!)
                                .font(.system(size: 14, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .italic()
                                .padding(.bottom, 5)
                        } else {
                            Text("prompt not loaded")
                                .font(.system(size: 14, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .italic()
                                .padding(.bottom, 5)
                        }
                        
                        
                        HStack {
                            // Profile Picture
                            if homeController.isFocusedShortOwned {
                                if let image = userController.usersProfilePicture {
                                    Image(uiImage: image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                } else {
                                    Image("not-signed-in-profile")
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                }
                            } else {
                                if let image = homeController.communityProfilePictures[short.authorId!] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                } else {
                                    Image("not-signed-in-profile")
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                }
                            }
                            
                            VStack {
                                // Handle
                                Text(short.authorFirstName! + " " + short.authorLastName!)
                                    .font(.system(size: 12, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Date posted
                                Text(short.rawTimestamp!.dateValue().formatted(date: .abbreviated, time: .shortened))
                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                        }
                        
                        // Response
                        Text(short.shortRawText!)
                            .font(.system(size: 13, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            
                            Button(action: {
                                homeController.likeShort()
                            }) {
                                ZStack {
                                    HStack {
                                        // Comment image
                                        Image(systemName: "hand.thumbsup")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        // comment number
                                        Text("\(short.likeCount!)")
                                            .font(.system(size: 13, design: .serif))
                                    }
                                    
                                    // if the short is liked, stack the orange one on top lmao
                                    if let short = homeController.focusedSingleShort {
                                        if let isLiked = homeController.likedShorts[short.id!] {
                                            if isLiked {
                                                HStack {
                                                    // Comment image
                                                    Image(systemName: "hand.thumbsup")
                                                        .resizable()
                                                        .frame(width: 15, height: 15)
                                                    // comment number
                                                    Text("\(short.likeCount!)")
                                                        .font(.system(size: 13, design: .serif))
                                                }
                                                .foregroundStyle(Color.orange)
                                            }
                                        }
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            HStack {
                                // Comment image
                                Image(systemName: "message")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                // comment number
                                Text("\(short.commentCount!)")
                                    .font(.system(size: 13, design: .serif))
                            }
                            
                            HStack {
                                // Report Short
                                Image(systemName: "exclamationmark.circle")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Text("Comments")
                            .font(.system(size: 13, design: .serif))
                        
                        Button(action: {
                            homeController.isCreateCommentSheetShowing = true
                        }) {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(lineWidth: 1)
                                .frame(width: 140, height: 40)
                                .overlay {
                                    HStack {
                                        // TODO(bendreyer): have a couple different openers here (start your creation, dive right in, etc..) and pick one at random
                                        Text("Add a comment")
                                            .font(.system(size: 10, design: .serif))
                                            .bold()
                                        
                                        Image(systemName: "message")
                                            .font(.caption)
                                        
                                    }
                                }
                                .padding(.bottom, 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 2)
                        
                        // Response Comments (hardcoded 3 for now)
//                        CommunityResponseComment(imageName: "space-guy", authorHandle: "southxx", timePosted: "7:45am", comment: "Really a substantial comment I appreciate your resiliancy in this area, lie forreal")
//                        CommunityResponseComment(imageName: "hoop-guy", authorHandle: "jokic", timePosted: "9:32pm", comment: "I'm not really sure how this relates to basketball at all. Please try again, 4/10.")
                        
                        // comments for the short
                        ForEach(homeController.focusedShortComments) { comment in
                            CommunityResponseComment(comment: comment)
                        }
                    }
                }
                .padding(20)
            } else {
                VStack {
                    Text("error loading short.. awkward")
                }
            }
        }
        .sheet(isPresented: $homeController.isCreateCommentSheetShowing) {
            // Create comment view
            CreateCommentView()
                .presentationDetents([.height(400), .medium])
                .presentationDragIndicator(.automatic)
        }
        
    }
}

#Preview {
    SingleCommunityResponseView()
        .environmentObject(HomeController())
        .environmentObject(UserController())
}
