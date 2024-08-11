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
    
    @EnvironmentObject var createShortController : CreateShortController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var profileController: ProfileController
    
//    @State private var response: String = ""
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                // Show focused prompt or a fallback if it's not loaded
                if let focusedPrompt = homeController.focusedPrompt {
                    if homeController.focusedPromptImage != nil {
                        TodaysPrompt(image: nil, prompt: focusedPrompt.promptRawText!, tags: focusedPrompt.tags!, likeCount: focusedPrompt.likeCount!, responseCount: focusedPrompt.shortCount!, includeResponseCount: true)
                    }
                } else {
                    TodaysPrompt(image: nil, prompt: "We couldn't load the prompt for the date you selected, sorry about that, please try a different date!", tags: ["Awkward"], likeCount: 0, responseCount: 0, includeResponseCount: true)
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
                            if createShortController.shortContent.isEmpty {
                                return
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
                                            
                                            createShortController.isCreateShortSheetShowing = false
                                        }
                                    } else {
                                        print("prompt not available")
                                    }
                                } else {
                                    print("user not available")
                                }
                            }
                        }
                    }) {
                        Image(systemName: "arrowshape.right.circle")
                            .font(.callout)
                            .foregroundStyle(createShortController.shortContent.count == 0 ? Color.gray : Color.green)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Spacer()
            }
        }
        .padding(.top, 20)
        .padding(.leading, 20)
        .padding(.trailing, 20)
//        .onAppear {
//            self.isTabBarShowing = false
//        }
//        .onDisappear {
//            self.isTabBarShowing = true
//        }
    }
}

#Preview {
    CreateResponseView()
        .environmentObject(CreateShortController())
        .environmentObject(UserController())
        .environmentObject(HomeController())
}
