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
    @EnvironmentObject var userController: UserController
    
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
                    
                    
                    HStack {
                        // Date posted
                        Text(comment.rawTimestamp!.dateValue().formatted(date: .abbreviated, time: .shortened))
                            .font(.system(size: 11, design: .serif))
                            .opacity(0.6)
//                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        // Info popup (where you can report, give feedback, etc..)
                        Button(action: {
                            homeController.isReportCommentAlertShowing = true
                        }) {
                            Image(systemName: "info.circle")
                                .font(.caption)
                                .padding(.trailing, 5)
                        }
                        .padding(.leading, 5)
                        .buttonStyle(PlainButtonStyle())
                        .alert("Report Comment", isPresented: $homeController.isReportCommentAlertShowing) {
                            Button("Offensive") {
                                if let rateLimit = userController.processFirestoreWrite() {
                                    print(rateLimit)
                                } else {
                                    homeController.reportComment(reportReason: "Offensive", commentId: self.comment.id!)
                                }
                            }
                            
                            Button("Harmful or Abusive") {
                                if let rateLimit = userController.processFirestoreWrite() {
                                    print(rateLimit)
                                } else {
                                    homeController.reportComment(reportReason: "Harmful or Abusive", commentId: self.comment.id!)
                                }
                            }
                            
                            Button("Graphic content") {
                                if let rateLimit = userController.processFirestoreWrite() {
                                    print(rateLimit)
                                } else {
                                    homeController.reportComment(reportReason: "Graphic content", commentId: self.comment.id!)
                                }
                            }
                            
                            Button("Poor Quality / Image does not match text") {
                                if let rateLimit = userController.processFirestoreWrite() {
                                    print(rateLimit)
                                } else {
                                    homeController.reportComment(reportReason: "Poor Quality / Image does not match text", commentId: self.comment.id!)
                                }
                            }
                            
                            Button("Cancel", role: .cancel) { }
                        }
                    }
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
