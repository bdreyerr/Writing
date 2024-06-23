//
//  ListCommunityResponseView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

// A full list of the community responses to a prompt (infinite scroll)
struct ListCommunityResponseView: View {
    @EnvironmentObject var homeController: HomeController
    
//    @State private var isSingleCommunityResponsePopupShowing: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    // If a prompt is fetched from firestore and loaded in the controller, show that. Else show the preview (loading) View.
                    if let focusedPrompt = homeController.focusedPrompt {
                        if let focusedImage = homeController.focusedPromptImage {
                            TodaysPrompt(image: focusedImage, prompt: focusedPrompt.promptRawText!, tags: focusedPrompt.tags!, likeCount: focusedPrompt.likeCount!, responseCount: focusedPrompt.shortCount!, includeResponseCount: true)
                        }
                    } else {
                        TodaysPrompt(imageText: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike"], likeCount: 173, responseCount: 47, includeResponseCount: true)
                    }
                    
                    // Sort By
                    HStack {
                        Text("Sort By")
                            .font(.system(size: 13, design: .serif))
                        Menu {
                            Button("Best", action: {
                                return
                            })
                            Button("Newest", action: {
                                return
                            })
                        } label: {
                            HStack {
                                Text("Best")
                                    .font(.system(size: 13, design: .serif))
                                
                                Image(systemName: "crown")
                                    .font(.subheadline)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    
                    // Single Limited Responses
                    
                    // if there's no shorts yet
                    if (homeController.focusedFullCommunityShorts.isEmpty) {
                        Text("No Community Shorts Yet")
                            .font(.system(size: 14, design: .serif))
                            .bold()
                            .opacity(0.7)
                    } else {
                        ForEach(homeController.focusedFullCommunityShorts) { short in
                            Button(action: {
//                                self.isSingleCommunityResponsePopupShowing.toggle()
                                // nothing for now
                            }) {
//                                SingleLimitedCommunityResponse(image: homeController.communityProfilePictures[short.authorId!] ?? UIImage(named: "not-signed-in-profile")!, authorHandle: short.authorFirstName! + " " + short.authorLastName!, timePosted: short.rawTimestamp!.dateValue().formatted(date: .abbreviated, time: .shortened), response: short.shortRawText!, numLikes: short.likeCount!, numComments: short.commentCount!)
                                SingleLimitedCommunityResponse(short: short, isOwnedShort: false)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
//                    
//                    // Load comments in 8s, use infinite scroll, not pagination.
//                    Button(action: {
//                        self.isSingleCommunityResponsePopupShowing.toggle()
//                    }) {
//                        SingleLimitedCommunityResponse(imageName: "wolf", authorHandle: "NedStarkDidntDie", timePosted: "4:38pm", responseLimited: "Sir Aldric knelt beside the injured dwarf, examining the wreckage. “We must help him,” urged young Liam, his squire. “But the bandits could return,” Aldric warned, eyes scanning the forest. The dwarf groaned...", numLikes: 13, numComments: 4)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    Button(action: {
//                        self.isSingleCommunityResponsePopupShowing.toggle()
//                    }) {
//                        SingleLimitedCommunityResponse(imageName: "space-guy", authorHandle: "Trisolarian21", timePosted: "6:21pm", responseLimited: "“About time someone showed up! Those bandits took everything, including my best ale!” Ben stifled a laugh. “We’ll get you to safety,” Roland assured.", numLikes: 11, numComments: 2)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    
//                    Button(action: {
//                        self.isSingleCommunityResponsePopupShowing.toggle()
//                    }) {
//                        SingleLimitedCommunityResponse(imageName: "hoop-guy", authorHandle: "Jokic", timePosted: "1:13pm", responseLimited: "The knight and his squire stumbled upon a chaotic scene: a carriage overturned, its contents strewn about, and a dwarf groaning on the ground. “They took my treasures!“ the dwarf lamented... ", numLikes: 4, numComments: 1)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    
//                    Button(action: {
//                        self.isSingleCommunityResponsePopupShowing.toggle()
//                    }) {
//                        SingleLimitedCommunityResponse(imageName: "wolf", authorHandle: "NedStarkDidntDie", timePosted: "4:38pm", responseLimited: "Sir Aldric knelt beside the injured dwarf, examining the wreckage. “We must help him,” urged young Liam, his squire. “But the bandits could return,” Aldric warned, eyes scanning the forest. The dwarf groaned...", numLikes: 13, numComments: 4)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    Button(action: {
//                        self.isSingleCommunityResponsePopupShowing.toggle()
//                    }) {
//                        SingleLimitedCommunityResponse(imageName: "space-guy", authorHandle: "Trisolarian21", timePosted: "6:21pm", responseLimited: "“About time someone showed up! Those bandits took everything, including my best ale!” Ben stifled a laugh. “We’ll get you to safety,” Roland assured.", numLikes: 11, numComments: 2)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    Button(action: {
//                        self.isSingleCommunityResponsePopupShowing.toggle()
//                    }) {
//                        SingleLimitedCommunityResponse(imageName: "hoop-guy", authorHandle: "Jokic", timePosted: "1:13pm", responseLimited: "The knight and his squire stumbled upon a chaotic scene: a carriage overturned, its contents strewn about, and a dwarf groaning on the ground. “They took my treasures!“ the dwarf lamented... ", numLikes: 4, numComments: 1)
//                    }
//                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
        }
        .padding(.bottom, 25)
        .onAppear {
            homeController.retrieveFullCommunityShorts()
        }
    }
}

#Preview {
    ListCommunityResponseView()
        .environmentObject(HomeController())
}
