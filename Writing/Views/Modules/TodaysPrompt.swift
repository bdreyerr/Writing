 //
//  TodaysPrompt.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct TodaysPrompt: View {
    var image: String
    var prompt: String
    var tags: [String]
    var likeCount: Int
    var responseCount: Int
    var includeResponseCount: Bool
    
    // Max Three Tags
    var tagColorOrder = [Color.red, Color.blue, Color.green]
    
    var body: some View {
        // Image
        Image(image)
            .resizable()
            .frame(maxWidth: 400, maxHeight: 300)
        
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
                HStack {
                    Image(systemName: "hand.thumbsup")
                        .font(.caption)
//                                    .resizable()
//                                    .frame(width: 15, height: 15)
                    // Like Count
                    Text("\(likeCount)")
                        .font(.system(size: 13, design: .serif))
                }
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
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    TodaysPrompt(image: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike", "Buboy"], likeCount: 173, responseCount: 47, includeResponseCount: true)
}
