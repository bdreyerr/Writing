//
//  SinglePersonalResponse.swift
//  Writing
//
//  Created by Ben Dreyer on 6/9/24.
//

import SwiftUI

struct SinglePersonalResponse: View {
    var imageName: String
    var authorHandle: String
    var timePosted: String
    var prompt: String
    var response: String
    var numLikes: Int
    var numComments: Int
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    Image("prompt2")
                        .resizable()
                        .frame(maxWidth: 400, maxHeight: 300)
                    
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
                    
                    
                    HStack {
                        // Edit Response
                        NavigationLink(destination: CreateResponseView()) {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(lineWidth: 1)
                                .frame(width: 150, height: 40)
                                .overlay {
                                    HStack {
                                        Text("Edit Your Short")
                                            .font(.system(size: 13, design: .serif))
                                            .bold()
                                        Image(systemName: "square.and.pencil")
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Analysis
                        NavigationLink(destination: HistoryAnalysisView()) {
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(lineWidth: 1)
                                .frame(width: 150, height: 40)
                                .overlay {
                                    HStack {
                                        Text("What We Think")
                                            .font(.system(size: 13, design: .serif))
                                            .bold()
                                        Image(systemName: "bolt")
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    
                    
                    Text("Comments")
                        .font(.system(size: 13, design: .serif))
                    
                    // Response Comments (hardcoded 3 for now)
                    CommunityResponseComment(imageName: "wolf", authorHandle: "southxx", timePosted: "7:45am", comment: "Really a substantial comment I appreciate your resiliancy in this area, lie forreal")
                    CommunityResponseComment(imageName: "hoop-guy", authorHandle: "jokic", timePosted: "9:32pm", comment: "I'm not really sure how this relates to basketball at all. Please try again, 4/10.")
                    
                    
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    SinglePersonalResponse(imageName: "space-guy", authorHandle: "Salvor Hardin", timePosted: "3:23pm", prompt: "The inconcievable universe seemed increddibly large for almost all of it's inhabitants. Except for Jackal Lend, maybe one of the only men in the Universe who truly understood its scale.", response: "Jackal Lend stood on the bridge of his starship, gazing out at the swirling galaxies beyond. To most, the cosmos was an endless expanse of mystery and wonder. But to Jackal, it was a map he had memorized long ago. He had traveled to the furthest reaches, seen stars born and die, and navigated the black holes' perilous edges. The universe’s vastness was no longer daunting; it was a puzzle he had pieced together, every fragment a testament to his relentless exploration. For Jackal Lend, the universe wasn't vast; it was home.", numLikes: 42, numComments: 13)
}
