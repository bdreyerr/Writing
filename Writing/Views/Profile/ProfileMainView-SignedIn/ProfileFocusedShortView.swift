//
//  ProfileFocusedShortView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/23/24.
//

import SwiftUI

struct ProfileFocusedShortView: View {
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var userController: UserController
    
    // Only need home controller to update the cache from the profile.
    @EnvironmentObject var homeController: HomeController
    
    @State var isEditShortViewActive: Bool = false
    
    var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    // ensure focused short is not nil
                    if let short = profileController.focusedShort {
                        // check image
                        if let image = profileController.promptImages[short.date!] {
                            if isIPad {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(maxWidth: 1000, maxHeight: 740)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            } else {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(maxWidth: 400, maxHeight: 370)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        } else {
//                            Image("wolf")
//                                .resizable()
//                                .frame(maxWidth: 400, maxHeight: 300)
                        }
                        
                        Text(short.promptRawText!)
                            .font(.system(size: 14, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                            .padding(.bottom, 5)
                        
                        HStack {
                            // Profile Picture
                            if let image = userController.usersProfilePicture {
                                Image(uiImage: image)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    .frame(width: 40, height: 40)
                            } else {
                                Image("not-signed-in-profile")
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    .frame(width: 40, height: 40)
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
                            HStack {
                                // Comment image
                                Image(systemName: "hand.thumbsup")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                // comment number
                                Text("\(short.likeCount!)")
                                    .font(.system(size: 13, design: .serif))
                            }
                            
                            HStack {
                                // Comment image
                                Image(systemName: "message")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                // comment number
                                Text("\(short.commentCount!)")
                                    .font(.system(size: 13, design: .serif))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                // Edit Short
                                NavigationLink(destination: ProfileEditShortView(), isActive: $isEditShortViewActive) {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(lineWidth: 1)
                                        .frame(width: 150, height: 40)
                                        .overlay {
                                            HStack {
                                                Text("Edit Your Short")
                                                    .font(.system(size: 13, design: .serif))
                                                    .bold()
                                                Image(systemName: "square.and.pencil")
                                            }
                                        }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.leading, 1)
                                
                                // Analysis
                                NavigationLink(destination: ShortAnalysisMainView()) {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(lineWidth: 1)
                                        .frame(width: 150, height: 40)
                                        .overlay {
                                            HStack {
                                                Text("What We Think")
                                                    .font(.system(size: 13, design: .serif))
                                                    .bold()
                                                Image(systemName: "bolt")
                                            }
                                        }
                                }
                                .foregroundStyle(Color.blue)
                                .buttonStyle(PlainButtonStyle())
                                
                                // Delete Short
                                Button(action: {
                                    profileController.isConfirmShortDelteAlertShowing = true
                                }) {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(lineWidth: 1)
                                        .frame(width: 170, height: 40)
                                        .overlay {
                                            HStack {
                                                Text("Delete Your Short")
                                                    .font(.system(size: 13, design: .serif))
                                                    .bold()
                                                Image(systemName: "trash")
                                            }
                                        }
                                }
                                .foregroundStyle(Color.red)
                                .buttonStyle(PlainButtonStyle())
                                .alert("Are you sure?", isPresented: $profileController.isConfirmShortDelteAlertShowing) {
                                    
                                    Button("Confirm") {
                                        if let rateLimit = userController.processFirestoreWrite() {
                                            print(rateLimit)
                                        } else {
                                            if let user = userController.user {
                                                Task {
                                                    profileController.deleteShort()
                                                    
                                                    // repull the shorts for the user in profile
                                                    profileController.retrieveShorts()
                                                    
                                                    // re-pull the user in user controller
                                                    userController.retrieveUserFromFirestore(userId: user.id!)
                                                    
                                                    // clear the deleted short from the cache in home controller
                                                    if let short = profileController.focusedShort {
                                                        homeController.clearEditedOrRemovedShortFromCache(shortDate: short.date!)
                                                    }
                                                }
                                            }
                                    }
                                }
                                    
                                    Button("Cancel", role: .cancel) { }
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
            .padding(20)
        }
        // Needed for iPad compliance
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ProfileFocusedShortView()
        .environmentObject(ProfileController())
        .environmentObject(UserController())
        .environmentObject(HomeController())
}
