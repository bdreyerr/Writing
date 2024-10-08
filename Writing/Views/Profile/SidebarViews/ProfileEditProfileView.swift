//
//  ProfileEditProfileView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/9/24.
//

import PhotosUI
import SwiftUI

struct ProfileEditProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        // Rate Limiting check
                        if let rateLimit = userController.processFirestoreWrite() {
                            print(rateLimit)
                        } else {
                            profileController.isChangePhotoSheetShowing = true
                        }
                    }) {
                        // current profile picture
                        if let image = userController.usersProfilePicture {
                            Image(uiImage: image).resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                .overlay(alignment: .topTrailing) {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 30))
                                        .padding(-12)
                                }
                        } else {
                            Image("not-signed-in-profile")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                .overlay(alignment: .topTrailing) {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 30))
                                        .padding(-12)
                                    
                                    
                                }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 25)
                    
                    // First and Last Name
                    if let user = userController.user {
                        Text(user.firstName! + " " + user.lastName!)
                            .font(.system(size: 24, design: .serif))
                            .bold()
                    } else {
                        Text("Guest Writer")
                            .font(.system(size: 24, design: .serif))
                            .bold()
                    }
                    
                    
                    Button(action: {
                        profileController.isChangeNameAlertShowing = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                    }
                    .alert("Edit Name", isPresented: $profileController.isChangeNameAlertShowing) {
                        
                        if colorScheme == .light {
                            TextField("First Name", text: $userController.newFirstName)
                                .foregroundStyle(Color.black)
                            TextField("Last Name", text: $userController.newLastName)
                                .foregroundStyle(Color.black)
                        } else if colorScheme == .dark {
                            TextField("First Name", text: $userController.newFirstName)
                                .foregroundStyle(Color.white)
                            TextField("Last Name", text: $userController.newLastName)
                                .foregroundStyle(Color.white)
                        }
                        
                        
                        HStack {
                            Button("Cancel", role: .cancel) {
                                profileController.isChangeNameAlertShowing = false
                            }.foregroundColor(.red)
                            Button("Save", role: .none) {
                                // Rate Limiting check
                                if let rateLimit = userController.processFirestoreWrite() {
                                    print(rateLimit)
                                } else {
                                    userController.changeName()
                                    profileController.isChangeNameAlertShowing = false
                                }
                            }.foregroundColor(.blue)
                        }
                    }
                    
                }
                Spacer()
            }
            .padding(.top, 40)
            .sheet(isPresented: $profileController.isChangePhotoSheetShowing) {
                ProfileChangePhotoView()
                    .presentationDetents([.height(400), .medium])
                    .presentationDragIndicator(.automatic)
            }
        }
    }
}

#Preview {
    ProfileEditProfileView()
        .environmentObject(ProfileController())
        .environmentObject(UserController())
}
