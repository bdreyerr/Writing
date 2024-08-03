//
//  CreateShortOrYourExistingShort.swift
//  Writing
//
//  Created by Ben Dreyer on 6/18/24.
//

import Combine
import SwiftUI

struct CreateShortOrYourExistingShort: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isTabBarShowing") private var isTabBarShowing = true
    
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var profileController: ProfileController
    @StateObject var createShortController = CreateShortController()
    
    @State var isKeyboardPresented = false
    
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
                    
                    HStack {
                        // User Profile Image
                        if let image = userController.usersProfilePicture {
                            Image(uiImage: image)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 40, height: 40)
                        }
                        
                        // User name and title
                        if let user = userController.user {
                            VStack {
                                // Handle
                                Text(user.firstName! + " " + user.lastName!)
                                    .font(.system(size: 12, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    // Author title
                                    Text(homeController.convertTitleIntToString(int: user.title ?? 0))
                                        .font(.system(size: 10, design: .serif))
                                        .opacity(0.6)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    
                    // Text Field
                    TextField("Once upon a time...",text: $createShortController.shortContent, axis: .vertical)
                        .font(.system(size: 16, design: .serif))
                        .padding(.vertical, 8)
                        .background(
                            VStack {
                                Spacer()
                                Color(UIColor.systemGray4)
                                    .frame(height: 2)
                            }
                        )
                        .onReceive(Just(createShortController.shortContent)) { _ in createShortController.limitTextLength(createShortController.characterLimit) }
                        .onReceive(keyboardPublisher) { value in
                            print("Is keyboard visible? ", value)
                            isKeyboardPresented = value
                            isTabBarShowing = !isKeyboardPresented
                        }
                    
                    HStack {
                        // Character Count
                        Text("\(createShortController.shortContent.count) / 2500 Characters")
                            .font(.system(size: 12, design: .serif))
                        
                        Button(action: {
                            // Rate Limiting check
                            if let rateLimit = userController.processFirestoreWrite() {
                                print(rateLimit)
                            } else {
                                
                                if createShortController.shortContent == "" {
                                    print("content empty")
                                    return
                                }
                                
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
                                            
                                            // show tab bar again
                                            self.isTabBarShowing = true
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
                                .foregroundStyle(createShortController.shortContent.count == 0 ? Color.gray : Color.green)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    Button(action: {
                        // enable show auth screen
                        authController.isAuthPopupShowing = true
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
                
                
            }
        }
        .onAppear {
            createShortController.shortContent = ""
        }
        .environmentObject(createShortController)
        
    }
    //    }
}

#Preview {
    CreateShortOrYourExistingShort()
        .environmentObject(HomeController())
        .environmentObject(UserController())
        .environmentObject(AuthController())
        .environmentObject(CreateShortController())
        .environmentObject(ProfileController())
}


extension View {

  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .Merge(
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillShowNotification)
          .map { _ in true },
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillHideNotification)
          .map { _ in false })
      .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}
