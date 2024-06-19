//
//  ProfileMainView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct ProfileMainViewNotSignedIn: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isSignUpViewShowing: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 0.0)
                    .edgesIgnoringSafeArea(.top)
                    .foregroundStyle(colorScheme == .light ? Color.black : Color.white)
                    .opacity(1.0)
                    .frame(minWidth: 300, maxWidth: 500, minHeight: 120, maxHeight: 120)
                
                Spacer()
            }
            
            VStack {
                VStack {
                    HStack {
                        
                        HStack {
                            // Share Profile
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                            
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .foregroundStyle(colorScheme == .light ? Color.white : Color.black)
                    
                    Image("not-signed-in-profile")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    
//                    HStack {
//                        Text("John Doe")
//                            .font(.system(size: 18, design: .serif))
//                            .bold()
//                        
//                        // TODO(bendreyer): streaks
//                        
//                    }
//                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 50)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            VStack {
                                Text("0")
                                    .font(.system(size: 20, design: .serif))
                                
                                Text("Shorts")
                                    .font(.system(size: 12, design: .serif))
                            }
                            //                                    .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            
                            
                            VStack {
                                Text("0")
                                    .font(.system(size: 20, design: .serif))
                                
                                Text("Likes")
                                    .font(.system(size: 12, design: .serif))
                            }
                            //                                    .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            
                            VStack {
                                Text("0")
                                    .font(.system(size: 20, design: .serif))
                                
                                Text("Avg")
                                    .font(.system(size: 12, design: .serif))
                            }
                            //                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding()
                        }
                        // Streaks
                        
                        // Recent Posts
                        
                        HStack {
                            Text("Your Shorts")
                                .font(.system(size: 22, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Menu {
                                    Button("Recent", action: {
                                        return
                                    })
                                    Button("Best", action: {
                                        return
                                    })
                                } label: {
                                    HStack {
                                        Text("Recent")
                                            .font(.system(size: 13, design: .serif))
                                        
                                        Image(systemName: "clock")
                                            .font(.subheadline)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 0.5) {
                        Text("Please sign up to view your shorts")
                            .font(.system(size: 14, design: .serif))
                            .padding(.bottom, 10)
                        
                        Button(action: {
                            self.isSignUpViewShowing = true
                        }) {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(lineWidth: 1)
                                .frame(width: 220, height: 40)
                                .overlay {
                                    HStack {
                                        Text("Create an account / Log In")
                                            .font(.system(size: 14, design: .serif))
                                            .bold()
                                    }
                                }
                                .padding(.bottom, 10)
                        }
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
                //                            .padding(.top, 50)
            }
            .blur(radius: isSignUpViewShowing ? 10.0 : 0.0)
            .onTapGesture {
                if (isSignUpViewShowing) {
                    isSignUpViewShowing = false
                }
            }
            
            if (isSignUpViewShowing) {
                SignUpOrIn()
            }
        }
        .edgesIgnoringSafeArea(.top)
        //                .padding(.top, 10)
    }
}

#Preview {
    ProfileMainViewNotSignedIn()
}
