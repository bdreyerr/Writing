//
//  FreeWriteSignedOutView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/17/24.
//

import SwiftUI

struct FreeWriteSignedOutView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isSignUpViewShowing: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                // Logo / Slogan / Free Write
                HStack {
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    Text("Free Write")
                        .font(.system(size: 16, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .bold()
                }
                .padding(.top, 15)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        // Writing Stats
                        HStack {
                            VStack {
                                Text("0")
                                    .font(.system(size: 20, design: .serif))
                                
                                Text("Entries")
                                    .font(.system(size: 12, design: .serif))
                            }
                            .padding()
                            
                            VStack {
                                Text("0")
                                    .font(.system(size: 20, design: .serif))
                                
                                Text("Avg Word Count")
                                    .font(.system(size: 12, design: .serif))
                            }
                            .padding()
                        }
                        
                        HStack {
                            Text("Latest Entries")
                                .font(.system(size: 16, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                            
                            Text("View All")
                                .font(.system(size: 12, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.bottom, 10)
                        
                        // Auth button
                        VStack(spacing: 0.5) {
                            Button(action: {
                                self.isSignUpViewShowing = true
                            }) {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 220, height: 40)
                                    .overlay {
                                        HStack {
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
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
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
        .padding(.bottom, 25)
    }
}

#Preview {
    FreeWriteSignedOutView()
}
