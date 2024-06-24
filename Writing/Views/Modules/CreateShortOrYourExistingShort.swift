//
//  CreateShortOrYourExistingShort.swift
//  Writing
//
//  Created by Ben Dreyer on 6/18/24.
//

import SwiftUI

struct CreateShortOrYourExistingShort: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var homeController: HomeController
    // TODO: put the userController here and pass in info that way about the author
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var authController: AuthController
    
    
    var body: some View {
        VStack {
            // If the users short is not nil in the home Controller, we should show the short. If it is nil, we should show a button that lets the user create their short
            
            if let short = homeController.usersFocusedShort {
                // Show the short if it exists
                Text("Your Response")
                    .font(.system(size: 16, design: .serif))
                    .bold()
                // Image name hardcoded for now
                SingleLimitedCommunityResponse(short: short, isOwnedShort: true)
            } else {
                // Otherwise the user can create a short.
                // But if they are not logged in force them to log in
                if (isSignedIn) {
                    NavigationLink(destination: CreateResponseView()) {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(lineWidth: 1)
                            .frame(width: 200, height: 40)
                            .overlay {
                                HStack {
                                    // TODO(bendreyer): have a couple different openers here (start your creation, dive right in, etc..) and pick one at random
                                    Text("Once upon a time...")
                                        .font(.system(size: 14, design: .serif))
                                        .bold()
                                    
                                    Image(systemName: "pencil.and.scribble")
                                    
                                }
                            }
                            .padding(.bottom, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        // enable show auth screen
                        authController.isAuthPopupShowing = true
                    }) {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(lineWidth: 1)
                            .frame(width: 200, height: 40)
                            .overlay {
                                HStack {
                                    // TODO(bendreyer): have a couple different openers here (start your creation, dive right in, etc..) and pick one at random
                                    Text("Once upon a time...")
                                        .font(.system(size: 14, design: .serif))
                                        .bold()
                                    
                                    Image(systemName: "pencil.and.scribble")
                                    
                                }
                            }
                            .padding(.bottom, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                
            }
            
            
        }
    }
    //    }
}

#Preview {
    CreateShortOrYourExistingShort()
        .environmentObject(HomeController())
        .environmentObject(UserController())
        .environmentObject(AuthController())
}
