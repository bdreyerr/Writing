//
//  CreateResponseView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI
import Combine

struct CreateResponseView: View {
    @AppStorage("isTabBarShowing") private var isTabBarShowing = true
    
    @StateObject var createShortController = CreateShortController()
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var profileController: ProfileController
    
//    @State private var response: String = ""
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // Show focused prompt or a fallback if it's not loaded
                if let focusedPrompt = homeController.focusedPrompt {
                    if let focusedImage = homeController.focusedPromptImage {
                        TodaysPrompt(image: focusedImage, prompt: focusedPrompt.promptRawText!, tags: focusedPrompt.tags!, likeCount: focusedPrompt.likeCount!, responseCount: focusedPrompt.shortCount!, includeResponseCount: true)
                    }
                } else {
                    TodaysPrompt(imageText: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike"], likeCount: 173, responseCount: 47, includeResponseCount: true)
                }
                
                // TODO(bendreyer): have a couple different openers here (once upon a time, in a land far far away, etc..) and pick one at random
                TextField("Once upon a time...",text: $createShortController.shortContent, axis: .vertical)
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
                // character limit
                    .onReceive(Just(createShortController.shortContent)) { _ in createShortController.limitTextLength(createShortController.characterLimit) }
                HStack {
                    // Character Count
                    Text("\(createShortController.shortContent.count) / 2500 Characters")
                        .font(.system(size: 12, design: .serif))
                    
                    Button(action: {
                        // Rate Limiting check
                        if let rateLimit = userController.processFirestoreWrite() {
                            print(rateLimit)
                        } else {
                            // Ensure user is available
                            if let user = userController.user {
                                // Ensure a prompt is focused
                                if let prompt = homeController.focusedPrompt {
                                    Task {
                                        createShortController.submitShort(user: user, prompt: prompt)
                                        
                                        // refresh, so the just submitted short will show up back on home view
                                        homeController.retrieveSignedInUsersShort()
                                        
                                        // refresh the profile view, so the new short shows up on the profile
                                        profileController.retrieveShorts()
                                        
                                        // refresh user stats
                                        userController.retrieveUserFromFirestore(userId: user.id!)
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
                
                Spacer()
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .onAppear {
            self.isTabBarShowing = false
        }
        .onDisappear {
            self.isTabBarShowing = true
        }
        .environmentObject(createShortController)
        
    }
}

#Preview {
    CreateResponseView()
        .environmentObject(CreateShortController())
        .environmentObject(UserController())
        .environmentObject(HomeController())
}
