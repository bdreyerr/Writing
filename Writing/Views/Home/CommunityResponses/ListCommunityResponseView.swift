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
    @EnvironmentObject var userController: UserController
    
//    @State private var isSingleCommunityResponsePopupShowing: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    // If a prompt is fetched from firestore and loaded in the controller, show that. Else show the preview (loading) View.
                    if let focusedPrompt = homeController.focusedPrompt {
                        if let focusedImage = homeController.focusedPromptImage {
                            TodaysPrompt(image: focusedImage, prompt: focusedPrompt.promptRawText!, tags: focusedPrompt.tags!, likeCount: focusedPrompt.likeCount!, responseCount: focusedPrompt.shortCount!, includeResponseCount: false)
                        }
                    } else {
                        TodaysPrompt(imageText: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike"], likeCount: 173, responseCount: 47, includeResponseCount: true)
                    }
                    
                    // Sort By
                    HStack {
                        Menu {
                            Button(action: {
                                homeController.sortFocusedListShorts(isByDate: true, isByLikes: false)
                            }) {
                                HStack {
                                    Text("Recent")
                                        .font(.system(size: 13, design: .serif))
                                    
                                    Image(systemName: "clock")
                                        .font(.subheadline)
                                }
                                
                            }
                            Button(action: {
                                homeController.sortFocusedListShorts(isByDate: false, isByLikes: true)
                            }) {
                                HStack {
                                    Text("Best")
                                        .font(.system(size: 13, design: .serif))
                                    
                                    Image(systemName: "crown")
                                        .font(.subheadline)
                                }
                            }
                        } label: {
                            HStack {
                                if homeController.listShortSortingMethod == 0 {
                                    Text("Recent")
                                        .font(.system(size: 13, design: .serif))
                                } else if homeController.listShortSortingMethod == 1 {
                                    Text("Best")
                                        .font(.system(size: 13, design: .serif))
                                }
                                Image(systemName: "chevron.down")
                                    .font(.subheadline)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    
                    
//                    HStack {
//                        Text("Sort By")
//                            .font(.system(size: 13, design: .serif))
//                        Menu {
//                            Button("Best HEY", action: {
//                                return
//                            })
//                            Button("Newest", action: {
//                                return
//                            })
//                        } label: {
//                            HStack {
//                                Text("Best")
//                                    .font(.system(size: 13, design: .serif))
//                                
//                                Image(systemName: "crown")
//                                    .font(.subheadline)
//                            }
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.bottom, 10)
                    
                    // Single Limited Responses
                    
                    
                    
                    // if there's no shorts yet
                    if (homeController.focusedFullCommunityShorts.isEmpty) {
                        // if user isn't set
//                        if userController.user == nil {
//                            Text("Sign In to View Community Shorts")
//                                .font(.system(size: 14, design: .serif))
//                                .bold()
//                                .opacity(0.7)
//                        } else {
//                            Text("No Community Shorts Yet")
//                                .font(.system(size: 14, design: .serif))
//                                .bold()
//                                .opacity(0.7)
//                        }
                    } else {
                        ForEach(homeController.focusedFullCommunityShorts) { short in
                            Button(action: {
//                                self.isSingleCommunityResponsePopupShowing.toggle()
                                // nothing for now
                            }) {

                                SingleLimitedCommunityResponse(short: short, isOwnedShort: false)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // older button
                        if !homeController.areNoShortsLeftToLoad {
                            Button(action: {
                                if let user = userController.user {
                                    homeController.retrieveNextFullCommunityShorts(blockedUsers: user.blockedUsers ?? [:])
                                }
                            }) {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 110, height: 35)
                                    .overlay {
                                        HStack {
                                            Text("Older")
                                                .font(.system(size: 14, design: .serif))
                                                .bold()
                                            
                                            Image(systemName: "arrow.down")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                        }
                                    }
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
        }
        .padding(.bottom, 25)
        .onAppear {
            if let user = userController.user {
                homeController.retrieveFullCommunityShorts(blockedUsers: user.blockedUsers ?? [:])
            }
            
        }
    }
}

#Preview {
    ListCommunityResponseView()
        .environmentObject(HomeController())
        .environmentObject(UserController())
}
