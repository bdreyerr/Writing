//
//  ProfileEditShortView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/24/24.
//

import Combine
import SwiftUI

struct ProfileEditShortView: View {
    @AppStorage("isTabBarShowing") private var isTabBarShowing = true
    
    
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // make sure a short is focused
                if let short = profileController.focusedShort {
                    // see if we have the prompt image
                    if let image = profileController.promptImages[short.date!] {
                        // Image
                        Image(uiImage: image)
                            .resizable()
                            .resizable()
                            .frame(maxWidth: 400, maxHeight: 300)
                        
                    }
                    
                    // Prompt Text
                    Text(short.promptRawText!)
                        .font(.system(size: 14, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic()
                        .padding(.bottom, 5)
                    
                    // TextField (initialize with the text that's already written for the short)
                    // TODO(bendreyer): have a couple different openers here (once upon a time, in a land far far away, etc..) and pick one at random
                    TextField("Once upon a time...",text: $profileController.newShortText, axis: .vertical)
    //                    .modifier(KeyboardAdaptive())
                        .font(.system(size: 16, design: .serif))
                    // Styling
                        .padding(.vertical, 8)
                        .background(
                            VStack {
                                Spacer()
                                Color(UIColor.systemGray4)
                                    .frame(height: 2)
                            }
                        )
                    // character limit -
                        .onReceive(Just(profileController.newShortText)) { _ in profileController.limitTextLength(profileController.characterLimit) }
                    
                    
                    HStack {
                        // Character Count
                        Text("\(profileController.newShortText.count) / 2500 Characters")
                            .font(.system(size: 12, design: .serif))
                        
                        Button(action: {
                            // Rate Limiting check
                            if let rateLimit = userController.processFirestoreWrite() {
                                print(rateLimit)
                            } else {
                                // Ensure user is available
                                if let _ = userController.user {
                                    // Ensure a short is focused
                                    if let _ = profileController.focusedShort {
                                        Task {
                                            profileController.editShort()
                                        }
                                    } else {
                                        print("prompt not available")
                                    }
                                } else {
                                    print("user not available")
                                }
                            }
                        }) {
                            Image(systemName: "arrowshape.right.circle")
                                .font(.callout)
                                .foregroundStyle(Color.green)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            self.isTabBarShowing = false
            
            // Set the text in the text field to what the focused short text is
            if let short = profileController.focusedShort {
                profileController.newShortText = short.shortRawText ?? ""
            }
            
        }
        .onDisappear {
            self.isTabBarShowing = true
        }
    }
}

#Preview {
    ProfileEditShortView()
        .environmentObject(ProfileController())
        .environmentObject(UserController())
}
