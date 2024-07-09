//
//  ProfileSuggestPromptView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/9/24.
//

import Combine
import SwiftUI

struct ProfileSuggestPromptView: View {
    @AppStorage("isTabBarShowing") private var isTabBarShowing = true
    
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        VStack {
            Text("Our app thrives on community suggested prompts, if you think you have a great idea and want others to write about it, please submit it here!")
                .font(.system(size: 16, design: .serif))
                .italic()
            
            TextField("In a far away land...",text: $profileController.suggestedPromptText, axis: .vertical)
            //                .modifier(KeyboardAdaptive())
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
                .onReceive(Just(profileController.suggestedPromptText)) { _ in profileController.limitTextLengthSuggestedPrompt(400) }
            HStack {
                // Character Count
                Text("\(profileController.suggestedPromptText.count) / 400 Characters")
                    .font(.system(size: 12, design: .serif))
                
                Button(action: {
                    // Rate Limiting check
                    if let rateLimit = userController.processFirestoreWrite() {
                        print(rateLimit)
                    } else {
                        if let user = userController.user {
                            profileController.submitPromptSuggestion(user: user)
                        }
                    }
                }) {
                    if !profileController.suggestedPromptText.isEmpty {
                        Image(systemName: "arrowshape.right.circle")
                            .font(.callout)
                            .foregroundStyle(Color.green)
                    } else {
                        Image(systemName: "arrowshape.right.circle")
                            .font(.callout)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .onAppear {
            self.isTabBarShowing = false
        }
        .onDisappear {
            self.isTabBarShowing = true
        }
        
    }
}

#Preview {
    ProfileSuggestPromptView()
        .environmentObject(ProfileController())
}
