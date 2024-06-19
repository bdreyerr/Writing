//
//  ListCommunityResponseView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

// A full list of the community responses to a prompt (infinite scroll)
struct ListCommunityResponseView: View {
    
    @State private var isSingleCommunityResponsePopupShowing: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    TodaysPrompt(imageText: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike"], likeCount: 173, responseCount: 47, includeResponseCount: false)
                    
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
                    
                    // Single Limited Responses
                    // Load comments in 8s, use infinite scroll, not pagination.
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
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }
            .sheet(isPresented: self.$isSingleCommunityResponsePopupShowing) {
                SingleCommunityResponseView(imageName: "wolf", authorHandle: "bob", timePosted: "1:41pm", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", response: "The seasoned knight, Sir Alistair, and his loyal squire, Thomas, stumbled upon a chaotic scene. The carriage lay in shambles, its contents scattered across the forest floor. An injured dwarf leaned against a tree, grimacing in pain. “Bandits ambushed me,“ he groaned, clutching his leg.\n\nThomas knelt beside the dwarf, examining his wounds. “He can't walk, Sir. We need to help him.“\n\nSir Alistair surveyed the area, his hand resting on his sword hilt. “We can't leave him here, but the bandits might still be close. We must be cautious.“\n\nThe dwarf nodded weakly. “I overheard them planning to attack a nearby village.“\n\nSir Alistair's eyes hardened with resolve. “Then we’ll take him to safety and warn the villagers. Justice will come later.“", numLikes: 14, numComments: 2)
            }
        }
    }
}

#Preview {
    ListCommunityResponseView()
}
