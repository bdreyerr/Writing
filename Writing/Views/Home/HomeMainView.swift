//
//  HomeMainView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/1/24.
//

import SwiftUI

struct HomeMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    @StateObject var createShortController = CreateShortController()
    
    // Date Range for the prompt picker
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2024, month: 8, day: 17)
//        let endComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())  // THIS IS WHAT'S USED IN PROD (WE DON'T WANT USERS TO GO PAST CURRENT DATE)
        let endComponents = DateComponents(year: 2024, month: 8, day: 30) // USE THIS IN DEV TO TEST FUTURE PROMPTS
        return calendar.date(from:startComponents)!
        ...
        calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Today's Prompt and Change Date Button
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
                        
                        DatePicker(
                            "",
                            selection: $homeController.promptSelectedDate,
                            in: dateRange,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .onChange(of: homeController.promptSelectedDate) {
                            homeController.retrievePrompt()
                            homeController.retrieveSignedInUsersShort()
                            homeController.focusedTopCommunityShorts = []
                            createShortController.shortContent = ""
                        }
                        
                    }
                    .padding(.top, 15)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                    ScrollView(showsIndicators: false) {
                        // If a prompt is fetched from firestore and loaded in the controller, show that. Else show the preview (loading) View.
                        if let focusedPrompt = homeController.focusedPrompt {
                            if let focusedImage = homeController.focusedPromptImage {
                                TodaysPrompt(image: focusedImage, prompt: focusedPrompt.promptRawText!, tags: focusedPrompt.tags!, likeCount: focusedPrompt.likeCount!, responseCount: focusedPrompt.shortCount!, includeResponseCount: true)
                            }
                        } else {
                            // only show the missing prompt if we are NOT currently loading the prompt
                            if !homeController.isPromptLoading {
                                TodaysPrompt(imageText: "missingPrompt", prompt: "We couldn't load the prompt for the date you selected, sorry about that, please try a different date!", tags: ["Awkward"], likeCount: 0, responseCount: 0, includeResponseCount: true)
                            }
                        }
                        
                        
                        // If the user has responded to the loaded prompt, it will show their response. Otherwise a button to create it.
                        CreateShortOrYourExistingShort()
                        
                        CommunityResponses()
                        
                        Spacer()
                        
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
                        Text("version 1.1")
                            .font(.system(size: 11, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            .opacity(0.8)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        if (authController.isAuthPopupShowing) {
                            authController.isAuthPopupShowing = false
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                }
                .blur(radius: authController.isAuthPopupShowing ? 10.0 : 0.0)
                
                
                if (authController.isAuthPopupShowing) {
                    SignUpOrIn()
                }
            }
            .padding(.bottom, 25)
        }
        // Needed for iPad compliance
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $homeController.isFullCommunityResposneSheetShowing) {
            SingleCommunityResponseView()
        }
        .onAppear {
            // We aren't worried about calling these functions on each view appear, because they retrieve cached data. We're not making a firestore read everytime the view re-appears, just making sure the data on screen is the most up to date.
            
            // Retrieve the prompt for the selected day
            homeController.retrievePrompt()
            // Retrieve the signed in users short for the selected day
            homeController.retrieveSignedInUsersShort()
        }
        .environmentObject(createShortController)
        
    }
}

#Preview {
    HomeMainView()
        .environmentObject(AuthController())
        .environmentObject(HomeController())
        .environmentObject(UserController())
        .environmentObject(CreateShortController())
}


struct CommunityResponses : View {
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    
//    @State public var areTopCommentsShowing: Bool = false
    
    var body : some View {
        VStack {
            Button(action: {
                if (!homeController.areTopCommentsShowing) {
                    if let user = userController.user {
                        homeController.retrieveTopCommunityShorts(blockedUsers: user.blockedUsers ?? [:])
                    }
                }
                homeController.areTopCommentsShowing.toggle()
            }) {
                if let _ = userController.user {
                    HStack {
                        Text("Top Community Shorts")
                            .font(.system(size: 14, design: .serif))
                            .bold()
                        
                        if (homeController.areTopCommentsShowing) {
                            Image(systemName: "chevron.up")
                                .resizable()
                                .frame(width: 18, height: 10)
                        } else {
                            Image(systemName: "chevron.down")
                                .resizable()
                                .frame(width: 18, height: 10)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Log in to view community responses")
                        .font(.system(size: 14, design: .serif))
                        .bold()
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            
            if (homeController.areTopCommentsShowing) {
                VStack {
                    // if there's no shorts yet
                    if (homeController.focusedTopCommunityShorts.isEmpty) {
                        // Just show nothing if there's no shorts yet, less jumpy when the view changes / loads.
                    } else {
                        ForEach(homeController.focusedTopCommunityShorts) { short in
                            SingleLimitedCommunityResponse(short: short, isOwnedShort: false)
                        }
                        
                        // View All Comments
                        NavigationLink(destination: ListCommunityResponseView()) {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(lineWidth: 1)
                                .frame(width: 130, height: 40)
                                .overlay {
                                    HStack {
                                        Text("All Shorts")
                                            .font(.system(size: 11, design: .serif))
                                        
                                        Image(systemName: "message")
                                            .font(.caption)
                                    }
                                }
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.leading, 2)
                    }
                }
            }
        }
    }
}
