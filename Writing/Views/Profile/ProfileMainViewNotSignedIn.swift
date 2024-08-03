//
//  ProfileMainView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct ProfileMainViewNotSignedIn: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var profileController: ProfileController
    
    //    @State private var isSignUpViewShowing: Bool = false
    
    
    var body: some View {
        ZStack {
            SideBarStack(sidebarWidth: 240, showSidebar: $profileController.showSidebar) {
                ProfileSidebarContentView()
            } content: {
                VStack {
                    HStack {
                        HStack {
                            Button(action: {
                                print("HELLO?")
                                profileController.showSidebar = true
                            }) {
                                Image(systemName: "text.justify")
                                    .font(.title3)
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Small Logo
                            if (colorScheme == .light) {
                                Image("LogoTransparentWhiteBackground")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            } else if (colorScheme == .dark) {
                                Image("LogoBlackBackground")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            
                            Text("| The Daily Short")
                                .font(.system(size: 16, design: .serif))
                                .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        // Side Menu activate
                        
                        
                        HStack {
                            // Share Profile
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                            
                            // Settings buttons
                            Button(action: {
                                profileController.isSettingsShowing = true
                            }) {
                                Image(systemName: "gearshape")
                                    .font(.title3)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                        //                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                    .padding(.top, 15)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            HStack {
                                VStack {
                                    
                                    Image("not-signed-in-profile")
                                        .resizable()
                                        .frame(maxWidth: 60, maxHeight: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    
                                    Text("Guest Writer")
                                        .font(.system(size: 16, design: .serif))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                }
                                .frame(minWidth: 100, maxWidth: 140, alignment: .leading)
                                
                                
                                HStack {
                                    
                                    VStack {
                                        Text("0")
                                            .font(.system(size: 18, design: .serif))
                                        
                                        Text("Shorts")
                                            .font(.system(size: 12, design: .serif))
                                    }
                                    .padding()
                                    VStack {
                                        Text("0")
                                            .font(.system(size: 18, design: .serif))
                                        
                                        Text("Likes")
                                            .font(.system(size: 12, design: .serif))
                                    }
                                    .padding()
                                    VStack {
                                        Text("0")
                                            .font(.system(size: 18, design: .serif))
                                        
                                        Text("Avg")
                                            .font(.system(size: 12, design: .serif))
                                    }
                                    .padding()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 20)
                            
                            // Streaks
                            
                            // Your Shorts
                            HStack {
                                Text("Your Shorts")
                                    .font(.system(size: 22, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        
                        VStack(spacing: 0.5) {
                            
                            Button(action: {
                                profileController.isSignUpViewShowing = true
                            }) {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 220, height: 40)
                                    .overlay {
                                        HStack {
                                            // TODO(bendreyer): have a couple different openers here (start your creation, dive right in, etc..) and pick one at random
                                            Text("Create Account / Sign In")
                                                .font(.system(size: 14, design: .serif))
                                                .bold()
                                            
                                            Image(systemName: "person.badge.plus")
                                            
                                        }
                                    }
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        VStack {
                            // Logo
                            if (colorScheme == .light) {
                                Image("LogoTransparentWhiteBackground")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            } else if (colorScheme == .dark) {
                                Image("LogoBlackBackground")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                            
                            Text("The Daily Short")
                                .font(.system(size: 15, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .bottom)
                                .opacity(0.8)
                            Text("version 1.1 june 2024")
                                .font(.system(size: 11, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .bottom)
                                .opacity(0.8)
                        }
                    }
                }
                .blur(radius: profileController.showSidebar ? 4.0 : 0.0)
            }
            .blur(radius: profileController.isSignUpViewShowing ? 10.0 : 0.0)
            .onTapGesture {
                if (profileController.isSignUpViewShowing) {
                    profileController.isSignUpViewShowing = false
                }
            }
            
            if (profileController.isSignUpViewShowing) {
                SignUpOrIn()
            }
        }
    }
}


#Preview {
    ProfileMainViewNotSignedIn()
        .environmentObject(ProfileController())
}
