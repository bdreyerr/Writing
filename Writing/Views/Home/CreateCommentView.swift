//
//  CreateCommentView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/22/24.
//

import SwiftUI

struct CreateCommentView: View {
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    var body: some View {
        ZStack {
            VStack {
                // The short the user's adding a comment to:
                if let short = homeController.focusedSingleShort {
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
                    Text(short.shortRawText!.prefix(200))
                        .font(.system(size: 13, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                    
                    // TODO(bendreyer): have a couple different openers here (once upon a time, in a land far far away, etc..) and pick one at random
                    TextField("Once upon a time...",text: $homeController.commentText, axis: .vertical)
                    //                    .modifier(KeyboardAdaptive())
                        .font(.system(size: 16, design: .serif))
                    // Styling
                        .padding(.vertical, 8)
                        .background(
                            VStack {
                                Spacer()
                                Color(UIColor.systemGray4)
                                    .frame(height: 2)
                            }
                        )
                    // TODO limit comment length
                    
                    
                    HStack {
                        // Character Count
                        Text("\(homeController.commentText.count) / 250 Characters")
                            .font(.system(size: 12, design: .serif))
                        
                        Button(action: {
                            // Ensure user is available
                            if let user = userController.user {
                                // Ensure a prompt is focused
                                if let _ = homeController.focusedPrompt {
                                    Task {
                                         // Submit comment
                                        homeController.submitComment(user: user)
                                        // refresh the comment list, so the newly submitted one will show up
//                                        homeController.retrieveSignedInUsersShort()
                                    }
                                } else {
                                    print("prompt not available")
                                }
                            } else {
                                print("user not available")
                            }
                        }) {
                            if homeController.commentText.isEmpty {
                                Image(systemName: "arrowshape.right.circle")
                                    .font(.callout)
                                    .foregroundStyle(Color.gray)
                            } else {
                                Image(systemName: "arrowshape.right.circle")
                                    .font(.callout)
                                    .foregroundStyle(Color.green)
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                } else {
                    Text("error loading the short, sorry :O")
                        .italic()
                }
                
                Spacer()
            }
            .padding(.top, 40)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
        }
    }
}

#Preview {
    CreateCommentView()
        .environmentObject(HomeController())
        .environmentObject(UserController())
}
