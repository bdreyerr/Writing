//
//  TodaysPrompt.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct TodaysPrompt: View {
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    
    var image: UIImage?
    var imageText: String?
    var prompt: String
    var tags: [String]
    var likeCount: Int
    var responseCount: Int
    var includeResponseCount: Bool
    
    // Max Three Tags
    var tagColorOrder = [Color.red, Color.blue, Color.green]
    
    var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        // Image
        if let img = image {
            if isIPad {
                Image(uiImage: img)
                    .resizable()
                    .frame(maxWidth: 1000, maxHeight: 740)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                Image(uiImage: img)
                    .resizable()
                    .frame(maxWidth: 400, maxHeight: 370)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        } else {
            if isIPad {
                Image(imageText ?? "")
                    .resizable()
                    .frame(maxWidth: 1000, maxHeight: 740)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                Image(imageText ?? "")
                    .resizable()
                    .frame(maxWidth: 400, maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        
        
        // Text
        Text(prompt)
            .font(.system(size: 14, design: .serif))
            .frame(maxWidth: .infinity, alignment: .leading)
            .italic()
            .padding(.bottom, 5)
        
        // Tags & Like Count
        HStack {
            Group {
                
                ForEach(Array(tags.enumerated()), id: \.element) { index, tag in
                    Text("#\(tag)")
                        .font(.system(size: 13, design: .serif))
                        .foregroundStyle(tagColorOrder[index % tagColorOrder.count])
                }
            }
            
            // Likes, Responses, Feedback, report, and admin button
            HStack {
                // Likes
                Button(action: {
                    // Rate Limiting check
                    if let rateLimit = userController.processFirestoreWrite() {
                        print(rateLimit)
                    } else {
                        if let user = userController.user {
                            if let userLikesPrompts = user.likedPrompts {
                                homeController.likePrompt(usersPromptLikes: userLikesPrompts)
                            } else {
                                homeController.likePrompt(usersPromptLikes: [:])
                            }
                        }
                        // check a prompt is focused
                        if let prompt = homeController.focusedPrompt {
                            userController.likePrompt(promptDate: prompt.date!)
                        }
                    }
                }) {
                    ZStack {
                        // Non colored like count (when a user hasn't liked this prompt)
                        HStack {
                            Image(systemName: "hand.thumbsup")
                                .font(.caption)
                            // Like Count
                            Text("\(likeCount.formatted())")
                                .font(.system(size: 13, design: .serif))
                        }
                        
                        // Colored like count (when a user has liked this prompt)
                        if let prompt = homeController.focusedPrompt {
                            if let user = userController.user {
                                if let likesPrompts = user.likedPrompts {
                                    if let isLiked = likesPrompts[prompt.date!] {
                                        if isLiked == true {
                                            HStack {
                                                Image(systemName: "hand.thumbsup")
                                                    .font(.caption)
                                                // Like Count
                                                Text("\(likeCount.formatted())")
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
                
                // Responses
                if (includeResponseCount) {
                    NavigationLink(destination: ListCommunityResponseView()) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.right")
                                .font(.caption)
                            // Response Count
                            Text("\(responseCount.formatted())")
                                .font(.system(size: 13, design: .serif))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                
                // Info popup (where you can report, give feedback, etc..)
                Button(action: {
                    homeController.isReportPromptAlertShowing = true
                }) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .padding(.trailing, 5)
                }
                .buttonStyle(PlainButtonStyle())
                .alert("Report Prompt", isPresented: $homeController.isReportPromptAlertShowing) {
                    Button("Offensive") {
                        // Rate Limiting check
                        if let rateLimit = userController.processFirestoreWrite() {
                            print(rateLimit)
                        } else {
                            homeController.reportPrompt(reportReason: "Offensive")
                        }
                    }
                    
                    Button("Harmful or Abusive") {
                        // Rate Limiting check
                        if let rateLimit = userController.processFirestoreWrite() {
                            print(rateLimit)
                        } else {
                            homeController.reportPrompt(reportReason: "Harmful or Abusive")
                        }
                    }
                    
                    Button("Graphic content") {
                        // Rate Limiting check
                        if let rateLimit = userController.processFirestoreWrite() {
                            print(rateLimit)
                        } else {
                            homeController.reportPrompt(reportReason: "Graphic content")
                        }
                    }
                    
                    Button("Poor Quality / Image does not match text") {
                        // Rate Limiting check
                        if let rateLimit = userController.processFirestoreWrite() {
                            print(rateLimit)
                        } else {
                            homeController.reportPrompt(reportReason: "Poor Quality / Image does not match text")
                        }
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }
                                
                // Admin button to add responses (for testing) (not AI yet)
                if let user = userController.user {
                    if user.isAdmin! == true {
                        Button(action: {
                            homeController.addCommunityShorts()
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.caption)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundStyle(Color.green)
                        .padding(.trailing, 5)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    TodaysPrompt(imageText: "", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike", "Buboy"], likeCount: 173, responseCount: 47, includeResponseCount: true)
        .environmentObject(HomeController())
        .environmentObject(UserController())
}
