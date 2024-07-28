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
                        
                        
                        // Prompt
                        if let prompt = homeController.focusedPrompt {
                            Text(prompt.promptRawText!)
                                .font(.system(size: 14, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .italic()
                                .padding(.bottom, 20)
                        } else {
                            Text("prompt not loaded")
                                .font(.system(size: 14, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .italic()
                                .padding(.bottom, 20)
                        }
                        
                        
                        HStack {
                            // Image
                            // Profile Picture
                            if homeController.isFocusedShortOwned {
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
                                // Name
                                Text(short.authorFirstName! + " " + short.authorLastName!)
                                    .font(.system(size: 15, design: .serif))
                                    .frame(maxWidth: 140, alignment: .leading)
                                    
                                // Date posted
                                Text(short.rawTimestamp!.dateValue().formatted(date: .abbreviated, time: .shortened))
                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.6)
                                    .frame(maxWidth: 140, alignment: .leading)
                            }
//                            .frame(maxWidth: 140, alignment: .leading)
                            .padding(.trailing, 10)
                            
                            
                            // Num Shorts
                            VStack {
                                if let author = homeController.focusedShortAuthor {
                                    Text("\(author.shortsCount!.formatted())")
                                        .font(.system(size: 16, design: .serif))
                                        .foregroundStyle(Color.green)
                                } else {
                                    Text("")
                                        .font(.system(size: 16, design: .serif))
                                        .foregroundStyle(Color.green)
                                }
                                
                                
                                Text("Shorts")
                                    .font(.system(size: 12, design: .serif))
                                
                            }
                            .padding(.leading, 15)
                            
                            // Num Likes
                            VStack {
                                if let author = homeController.focusedShortAuthor {
                                    Text("\(author.numLikes!.formatted())")
                                        .font(.system(size: 16, design: .serif))
                                        .foregroundStyle(Color.blue)
                                } else {
                                    Text("")
                                        .font(.system(size: 16, design: .serif))
                                        .foregroundStyle(Color.blue)
                                }
                                
                                
                                Text("Likes")
                                    .font(.system(size: 12, design: .serif))
                                
                            }
                            .padding(.leading, 15)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                    
                        
                        // Response
                        Text(short.shortRawText!)
                            .font(.system(size: 13, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            
                            Button(action: {
                                // Rate Limiting check
                                if let rateLimit = userController.processFirestoreWrite() {
                                    print(rateLimit)
                                } else {
                                    if let user = userController.user {
                                        if let shortsLikes = user.likedShorts {
                                            homeController.likeShort(usersShortsLikes: shortsLikes)
                                        } else {
                                            homeController.likeShort(usersShortsLikes: [:])
                                        }
                                    }
                                    
                                    // check a short is focused
                                    if let short = homeController.focusedSingleShort {
                                        userController.likeShort(shortId: short.id!)
                                    }
                                    
                                }
                            }) {
                                ZStack {
                                    // Unliked like count (no color)
                                    HStack {
                                        // Comment image
                                        Image(systemName: "hand.thumbsup")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        // comment number
                                        Text("\(short.likeCount!.formatted())")
                                            .font(.system(size: 13, design: .serif))
                                    }
                                    
                                    // Liked like count (color)
                                    if let short = homeController.focusedSingleShort {
                                        if let user = userController.user {
                                            if let likesShorts = user.likedShorts {
                                                if let isLiked = likesShorts[short.id!] {
                                                    if isLiked == true {
                                                        HStack {
                                                            // Comment image
                                                            Image(systemName: "hand.thumbsup")
                                                                .resizable()
                                                                .frame(width: 15, height: 15)
                                                            // comment number
                                                            Text("\(short.likeCount!.formatted())")
                                                                .font(.system(size: 13, design: .serif))
                                                        }
                                                        .foregroundStyle(Color.orange)
                                                    }
                                                }
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
                                Text("\(short.commentCount!.formatted())")
                                    .font(.system(size: 13, design: .serif))
                            }
                            
                            
                            
                            
                            Button(action: {
                                homeController.isReportShortAlertShowing = true
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.caption)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .alert("Report Short", isPresented: $homeController.isReportShortAlertShowing) {
                                Button("Offensive") {
                                    // Rate Limiting check
                                    if let rateLimit = userController.processFirestoreWrite() {
                                        print(rateLimit)
                                    } else {
                                        homeController.reportShort(reportReason: "Offensive")
                                    }
                                }
                                
                                Button("Harmful or Abusive") {
                                    // Rate Limiting check
                                    if let rateLimit = userController.processFirestoreWrite() {
                                        print(rateLimit)
                                    } else {
                                        homeController.reportShort(reportReason: "Harmful or Abusive")
                                    }
                                }
                                
                                Button("Graphic content") {
                                    // Rate Limiting check
                                    if let rateLimit = userController.processFirestoreWrite() {
                                        print(rateLimit)
                                    } else {
                                        homeController.reportShort(reportReason: "Graphic content")
                                    }
                                }
                                
                                Button("Poor Quality / Image does not match text") {
                                    // Rate Limiting check
                                    if let rateLimit = userController.processFirestoreWrite() {
                                        print(rateLimit)
                                    } else {
                                        homeController.reportShort(reportReason: "Poor Quality / Image does not match text")
                                    }
                                }
                                
                                Button("Block User") {
                                    // Rate Limiting check
                                    if let rateLimit = userController.processFirestoreWrite() {
                                        print(rateLimit)
                                    } else {
                                        if let short = homeController.focusedSingleShort {
                                            userController.blockUser(userId: short.authorId!)
                                        }
                                        
                                    }
                                }
                                
                                Button("Cancel", role: .cancel) { }
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
                        
                        if !homeController.areNoCommentsLeftToLoad {
                            Button(action: {
                                if let user = userController.user {
                                    homeController.retrieveNextShortComments()
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 110, height: 35)
                                    .overlay {
                                        HStack {
                                            Text("Older")
                                                .font(.system(size: 14, design: .serif))
                                            //                                            .bold()
                                            
                                            Image(systemName: "arrow.down")
                                            
                                        }
                                    }
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
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
