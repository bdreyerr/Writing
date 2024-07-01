//
//  ProfileFocusedShortView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/23/24.
//

import SwiftUI

struct ProfileFocusedShortView: View {
    @EnvironmentObject var profileController: ProfileController
    
    @State var isEditShortViewActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    // ensure focused short is not nil
                    if let short = profileController.focusedShort {
                        // check image
                        if let image = profileController.promptImages[short.date!] {
                            Image(uiImage: image)
                                .resizable()
                                .frame(maxWidth: 400, maxHeight: 300)
                        } else {
                            Image("wolf")
                                .resizable()
                                .frame(maxWidth: 400, maxHeight: 300)
                        }
                        
                        Text(short.promptRawText!)
                            .font(.system(size: 14, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .italic()
                            .padding(.bottom, 5)
                        
                        HStack {
                            // Profile Picture
                            Image("not-signed-in-profile")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                            
                            
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
                            
                            // Analysis
                            NavigationLink(destination: HistoryAnalysisView()) {
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
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    ProfileFocusedShortView()
        .environmentObject(ProfileController())
}
