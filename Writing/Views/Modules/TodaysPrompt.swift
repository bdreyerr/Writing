//
//  TodaysPrompt.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct TodaysPrompt: View {
    @EnvironmentObject var homeController: HomeController
    
    var image: UIImage?
    var imageText: String?
    var prompt: String
    var tags: [String]
    var likeCount: Int
    var responseCount: Int
    var includeResponseCount: Bool
    
    // Max Three Tags
    var tagColorOrder = [Color.red, Color.blue, Color.green]
    
    var body: some View {
        // Image
        if let img = image {
            Image(uiImage: img)
                .resizable()
                .frame(maxWidth: 400, maxHeight: 300)
        } else {
            Image(imageText ?? "prompt-knight")
                .resizable()
                .frame(maxWidth: 400, maxHeight: 300)
        }
        
        
        // Text
        Text(prompt)
            .font(.system(size: 14, design: .serif))
            .frame(maxWidth: .infinity, alignment: .leading)
            .italic()
            .padding(.bottom, 5)
        
        // Tags & Like Count
        HStack {
            Group {
                
                ForEach(Array(tags.enumerated()), id: \.element) { index, tag in
                    Text("#\(tag)")
                        .font(.system(size: 13, design: .serif))
                        .foregroundStyle(tagColorOrder[index % tagColorOrder.count])
                }
            }
            
            // Likes and Responses Buttons
            HStack {
                // Likes
                Button(action: {
                    homeController.likePrompt()
                }) {
                    ZStack {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                                .font(.caption)
                            //                                    .resizable()
                            //                                    .frame(width: 15, height: 15)
                            // Like Count
                            Text("\(likeCount)")
                                .font(.system(size: 13, design: .serif))
                        }
                        
                        // if a prompt is focused
                        if let prompt = homeController.focusedPrompt {
                            // if that prompt is liked, change the color to green
                            if let isLiked = homeController.likedPrompts[prompt.date!] {
                                if isLiked == true {
                                    HStack {
                                        Image(systemName: "hand.thumbsup")
                                            .font(.caption)
                                        //                                    .resizable()
                                        //                                    .frame(width: 15, height: 15)
                                        // Like Count
                                        Text("\(likeCount)")
                                            .font(.system(size: 13, design: .serif))
                                    }
                                    .foregroundStyle(Color.orange)
                                }
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Responses
                if (includeResponseCount) {
                    NavigationLink(destination: ListCommunityResponseView()) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.right")
                                .font(.caption)
                            // Response Count
                            Text("\(responseCount)")
                                .font(.system(size: 13, design: .serif))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                
                // Report Prompt
                Image(systemName: "exclamationmark.circle")
                    .font(.caption)
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    TodaysPrompt(imageText: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike", "Buboy"], likeCount: 173, responseCount: 47, includeResponseCount: true)
        .environmentObject(HomeController())
}
