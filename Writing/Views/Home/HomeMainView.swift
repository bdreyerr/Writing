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
                    
                        // Community Responses
                        CommunityResponses()
                            .padding(.bottom, 20)
                        
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
    }
}

#Preview {
    HomeMainView()
        .environmentObject(AuthController())
        .environmentObject(HomeController())
}


struct CommunityResponses : View {
    
    @State private var areTopCommentsShowing: Bool = false
    @State private var isSingleCommunityResponsePopupShowing: Bool = false
    
    var body : some View {
        VStack {
            Button(action: {
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
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if (areTopCommentsShowing) {
                
                VStack {
                    Button(action: {
                        self.isSingleCommunityResponsePopupShowing.toggle()
                    }) {
                        SingleLimitedCommunityResponse(imageName: "wolf", authorHandle: "NedStarkDidntDie", timePosted: "4:38pm", responseLimited: "Sir Aldric knelt beside the injured dwarf, examining the wreckage. “We must help him,” urged young Liam, his squire. “But the bandits could return,” Aldric warned, eyes scanning the forest. The dwarf groaned...", numLikes: 13, numComments: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    Button(action: {
                        self.isSingleCommunityResponsePopupShowing.toggle()
                    }) {
                        SingleLimitedCommunityResponse(imageName: "space-guy", authorHandle: "Trisolarian21", timePosted: "6:21pm", responseLimited: "“About time someone showed up! Those bandits took everything, including my best ale!” Ben stifled a laugh. “We’ll get you to safety,” Roland assured.", numLikes: 11, numComments: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        self.isSingleCommunityResponsePopupShowing.toggle()
                    }) {
                        SingleLimitedCommunityResponse(imageName: "hoop-guy", authorHandle: "Jokic", timePosted: "1:13pm", responseLimited: "The knight and his squire stumbled upon a chaotic scene: a carriage overturned, its contents strewn about, and a dwarf groaning on the ground. “They took my treasures!“ the dwarf lamented... ", numLikes: 4, numComments: 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                                    
                    // View All Comments
                    NavigationLink(destination: ListCommunityResponseView()) {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(lineWidth: 1)
                            .frame(width: 130, height: 40)
                            .overlay {
                                HStack {
                                    Text("All Comments")
                                        .font(.system(size: 11, design: .serif))
                                    
                                    Image(systemName: "message")
                                        .font(.caption)
                                }
                            }
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .sheet(isPresented: $isSingleCommunityResponsePopupShowing) {
            SingleCommunityResponseView(imageName: "wolf", authorHandle: "bob", timePosted: "1:41pm", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", response: "The seasoned knight, Sir Alistair, and his loyal squire, Thomas, stumbled upon a chaotic scene. The carriage lay in shambles, its contents scattered across the forest floor. An injured dwarf leaned against a tree, grimacing in pain. “Bandits ambushed me,“ he groaned, clutching his leg.\n\nThomas knelt beside the dwarf, examining his wounds. “He can't walk, Sir. We need to help him.“\n\nSir Alistair surveyed the area, his hand resting on his sword hilt. “We can't leave him here, but the bandits might still be close. We must be cautious.“\n\nThe dwarf nodded weakly. “I overheard them planning to attack a nearby village.“\n\nSir Alistair's eyes hardened with resolve. “Then we’ll take him to safety and warn the villagers. Justice will come later.“", numLikes: 14, numComments: 2)
        }
    }
}
