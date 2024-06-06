//
//  SingleCommunityResponseView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct SingleCommunityResponseView: View {
    
    var imageName: String
    var authorHandle: String
    var timePosted: String
    var prompt: String
    var response: String
    var numLikes: Int
    var numComments: Int
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                // Handle
                Text(authorHandle)
                    .font(.system(size: 14, design: .serif))
                
                HStack {
                    
                    HStack {
                        // Image
                        Image(imageName)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                    }
                    .padding()
                    
                    VStack {
                        Text("63")
                            .font(.system(size: 16, design: .serif))
                            .foregroundStyle(Color.green)
                        
                        Text("Responses")
                            .font(.system(size: 12, design: .serif))
                        
                    }
                    
                    VStack {
                        Text("1.4k")
                            .font(.system(size: 16, design: .serif))
                            .foregroundStyle(Color.blue)
                        
                        Text("Likes")
                            .font(.system(size: 12, design: .serif))
                        
                    }
                }
                
                Text(prompt)
                    .font(.system(size: 14, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .italic()
                    .padding(.bottom, 5)
                
                HStack {
                    // Profile Picture
                    Image(imageName)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    
                    
                    VStack {
                        // Handle
                        Text(authorHandle)
                            .font(.system(size: 12, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Date posted
                        Text(timePosted)
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
                
                // Response
                Text(response)
                    .font(.system(size: 13, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    HStack {
                        // Comment image
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .frame(width: 15, height: 15)
                        // comment number
                        Text("\(numLikes)")
                            .font(.system(size: 13, design: .serif))
                    }
                    
                    HStack {
                        // Comment image
                        Image(systemName: "message")
                            .resizable()
                            .frame(width: 15, height: 15)
                        // comment number
                        Text("\(numComments)")
                            .font(.system(size: 13, design: .serif))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text("Comments")
                    .font(.system(size: 13, design: .serif))
                
                // Response Comments (hardcoded 3 for now)
                CommunityResponseComment(imageName: "space-guy", authorHandle: "southxx", timePosted: "7:45am", comment: "Really a substantial comment I appreciate your resiliancy in this area, lie forreal")
                CommunityResponseComment(imageName: "hoop-guy", authorHandle: "jokic", timePosted: "9:32pm", comment: "I'm not really sure how this relates to basketball at all. Please try again, 4/10.")
                
                
            }
        }
        .padding(20)
    }
}

#Preview {
    SingleCommunityResponseView(imageName: "wolf", authorHandle: "bob", timePosted: "1:41pm", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", response: "The seasoned knight, Sir Alistair, and his loyal squire, Thomas, stumbled upon a chaotic scene. The carriage lay in shambles, its contents scattered across the forest floor. An injured dwarf leaned against a tree, grimacing in pain. “Bandits ambushed me,“ he groaned, clutching his leg.\n\nThomas knelt beside the dwarf, examining his wounds. “He can't walk, Sir. We need to help him.“\n\nSir Alistair surveyed the area, his hand resting on his sword hilt. “We can't leave him here, but the bandits might still be close. We must be cautious.“\n\nThe dwarf nodded weakly. “I overheard them planning to attack a nearby village.“\n\nSir Alistair's eyes hardened with resolve. “Then we’ll take him to safety and warn the villagers. Justice will come later.“", numLikes: 14, numComments: 2)
}
