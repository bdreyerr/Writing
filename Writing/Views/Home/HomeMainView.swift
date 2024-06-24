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
    
    // Date Range for the prompt picker
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2024, month: 6, day: 16)
        let endComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
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
                            TodaysPrompt(imageText: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike"], likeCount: 173, responseCount: 47, includeResponseCount: true)
                        }
                        
                        
                        // If the user has responded to the loaded prompt, it will show their response. Otherwise a button to create it.
                        CreateShortOrYourExistingShort()
                        
                        CommunityResponses()
                        
                        Spacer()
                        
                        Button(action: {
                            authController.isAuthPopupShowing.toggle()
                        }) {
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
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        if (authController.isAuthPopupShowing) {
                            authController.isAuthPopupShowing = false
                        }
                    }
                }
                .blur(radius: authController.isAuthPopupShowing ? 10.0 : 0.0)
                
                
                if (authController.isAuthPopupShowing) {
                    SignUpOrIn()
                }
            }
            .padding(.bottom, 25)
        }
        .sheet(isPresented: $homeController.isFullCommunityResposneSheetShowing) {
            SingleCommunityResponseView()
        }
        .onAppear {
            print("testing, getting called right now in on Appear")
            
            // We aren't worried about calling these functions on each view appear, because they retrieve cached data. We're not making a firestore read everytime the view re-appears, just making sure the data on screen is the most up to date.
            
            // Retrieve the prompt for the selected day
            homeController.retrievePrompt()
            // Retrieve the signed in users short for the selected day
            homeController.retrieveSignedInUsersShort()
        }
    }
}

#Preview {
    HomeMainView()
        .environmentObject(AuthController())
        .environmentObject(HomeController())
        .environmentObject(UserController())
}


struct CommunityResponses : View {
    @EnvironmentObject var homeController: HomeController
    
    @State private var areTopCommentsShowing: Bool = false
    
    var body : some View {
        VStack {
            Button(action: {
                if (!areTopCommentsShowing) {
                    homeController.retrieveTopCommunityShorts()
                }
                areTopCommentsShowing.toggle()
            }) {
                HStack {
                    Text("View Top Shorts")
                        .font(.system(size: 14, design: .serif))
                        .bold()
                    
                    if (areTopCommentsShowing) {
                        Image(systemName: "arrowtriangle.up")
                            .resizable()
                            .frame(width: 13, height: 10)
                    } else {
                        Image(systemName: "arrowtriangle.down")
                            .resizable()
                            .frame(width: 13, height: 10)
                    }
                    
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            
            if (areTopCommentsShowing) {
                VStack {
                    // if there's no shorts yet
                    if (homeController.focusedTopCommunityShorts.isEmpty) {
                        // Just show nothing if there's no shorts yet, less jumpy when the view changes / loads.
                    } else {
                        ForEach(homeController.focusedTopCommunityShorts) { short in
//                            SingleLimitedCommunityResponse(image: homeController.communityProfilePictures[short.authorId!] ?? UIImage(named: "not-signed-in-profile")!, authorHandle: short.authorFirstName! + " " + short.authorLastName!, timePosted: short.rawTimestamp!.dateValue().formatted(date: .abbreviated, time: .shortened), response: short.shortRawText!, numLikes: short.likeCount!, numComments: short.commentCount!)
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
