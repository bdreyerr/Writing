//
//  ListCommunityResponseView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct ListCommunityResponseView: View {
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    TodaysPrompt(image: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike"], likeCount: 173, responseCount: 47, includeResponseCount: false)
                    
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
                    
                    
                    // Load comments in 8s, use infinite scroll, not pagination.
                    SingleLimitedCommunityResponse(imageName: "wolf", authorHandle: "NedStarkDidntDie", timePosted: "4:38pm", responseLimited: "Sir Aldric knelt beside the injured dwarf, examining the wreckage. “We must help him,” urged young Liam, his squire. “But the bandits could return,” Aldric warned, eyes scanning the forest. The dwarf groaned...", numLikes: 13, numComments: 4)
                    
                    SingleLimitedCommunityResponse(imageName: "space-guy", authorHandle: "Trisolarian21", timePosted: "6:21pm", responseLimited: "“About time someone showed up! Those bandits took everything, including my best ale!” Ben stifled a laugh. “We’ll get you to safety,” Roland assured.", numLikes: 11, numComments: 2)
                    
                    SingleLimitedCommunityResponse(imageName: "hoop-guy", authorHandle: "Jokic", timePosted: "1:13pm", responseLimited: "The knight and his squire stumbled upon a chaotic scene: a carriage overturned, its contents strewn about, and a dwarf groaning on the ground. “They took my treasures!“ the dwarf lamented... ", numLikes: 4, numComments: 1)
                    
                    SingleLimitedCommunityResponse(imageName: "wolf", authorHandle: "NedStarkDidntDie", timePosted: "4:38pm", responseLimited: "Sir Aldric knelt beside the injured dwarf, examining the wreckage. “We must help him,” urged young Liam, his squire. “But the bandits could return,” Aldric warned, eyes scanning the forest. The dwarf groaned...", numLikes: 13, numComments: 4)
                    
                    SingleLimitedCommunityResponse(imageName: "space-guy", authorHandle: "Trisolarian21", timePosted: "6:21pm", responseLimited: "“About time someone showed up! Those bandits took everything, including my best ale!” Ben stifled a laugh. “We’ll get you to safety,” Roland assured.", numLikes: 11, numComments: 2)
                    
                    SingleLimitedCommunityResponse(imageName: "hoop-guy", authorHandle: "Jokic", timePosted: "1:13pm", responseLimited: "The knight and his squire stumbled upon a chaotic scene: a carriage overturned, its contents strewn about, and a dwarf groaning on the ground. “They took my treasures!“ the dwarf lamented... ", numLikes: 4, numComments: 1)
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
        }
    }
}

#Preview {
    ListCommunityResponseView()
}
