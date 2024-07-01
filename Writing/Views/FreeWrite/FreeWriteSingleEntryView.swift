//
//  FreeWriteSingleEntryView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/16/24.
//

import SwiftUI

struct FreeWriteSingleEntryView: View {
    @EnvironmentObject var freeWriteController: FreeWriteController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        if let freeWrite = freeWriteController.focusedFreeWrite {
            NavigationView {
                VStack {
                    HStack {
                        // Profile Picture
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
                        
                        
                        // Name and time posted
                        VStack {
                            // Title
                            Text((userController.user?.firstName ?? "Guest ") + " " + (userController.user?.lastName ?? "Writer"))
                                .font(.system(size: 12, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Date
                            Text("\(freeWrite.rawTimestamp!.dateValue().formatted(date: .abbreviated, time: .shortened))")
                                .font(.system(size: 12, design: .serif))
                                .opacity(0.6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Image(systemName: freeWrite.symbol!)
                            .font(.headline)
                    }
                    .padding(.bottom, 10)
                    
                    // Title
                    Text(freeWrite.title!)
                        .font(.system(size: 20, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    // Content
                    ScrollView(showsIndicators: false) {
                        
                        Text(freeWrite.content!)
                            .font(.system(size: 16, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        
                        HStack {
                            NavigationLink(destination: FreeWriteEditEntryView()) {
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
                            
                            .padding(.leading, 2)
                            
                            Button(action: {
                                freeWriteController.isConfirmDeleteAlertShowing = true
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
                            //                            .frame(maxWidth: .infinity, alignment: .leading)
                            .alert("Are you sure?", isPresented: $freeWriteController.isConfirmDeleteAlertShowing) {
                                Button("Confirm") {
                                    // Remove free write entry
                                    if let user = userController.user {
                                        Task {
                                            freeWriteController.deleteFreeWrite(freeWriteCount: user.freeWriteCount!, averageWordCountBeforeDeletion: user.freeWriteAverageWordCount!)
                                            
                                            // re-pull the freewrites for the user
                                            freeWriteController.retrieveFreeWrites()
                                            
                                            // re-pull the user in user controller
                                            print("right before calling refresh user")
                                            userController.retrieveUserFromFirestore(userId: user.id!)
                                        }
                                        
                                        print("right after the task in the view for delete")
                                    }
                                }
                                
                                Button("Cancel", role: .cancel) { }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
        } else {
            Text("we had trouble loading your entry, sawwwyy :((")
                .italic()
        }
        
    }
}

#Preview {
    FreeWriteSingleEntryView()
        .environmentObject(FreeWriteController())
}
