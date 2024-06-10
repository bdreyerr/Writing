//
//  HistoryAnalysisView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/1/24.
//

import SwiftUI

struct HistoryAnalysisView: View {
    @State private var isAnalysisHelpPopoverShowing = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    Image(systemName: "bolt.circle")
                        .font(.title)
                        .foregroundStyle(Color.blue)
                    
                    Text("What You Wrote")
                        .font(.system(size: 16, design: .serif))
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .bold()
                    
                    
                    Text("In the sprawling arena orbiting Earth, athletes from across the galaxy floated in zero-gravity, poised for the ultimate showdown. Representing diverse planets, their bodies adapted to unique environments, each competitor brought unparalleled skills and strategies. The crowd, an interstellar mix, watched in awe as the tournament began. Kira, Earth's champion, twisted mid-air, executing moves impossible under gravity's pull. Her opponent, a Martian with enhanced reflexes, countered with lightning speed. The clash was a breathtaking dance of agility and precision, a testament to human evolution and extraterrestrial prowess. As Kira scored the winning point, cheers erupted, echoing through the cosmos.")
                        .font(.system(size: 13, design: .serif))
                    
                    
                    HStack {
                        Text("What We Think")
                            .font(.system(size: 16, design: .serif))
                            .padding(.top, 15)
                            .padding(.bottom, 15)
                            .bold()
                        
                        
                        Button {
                            isAnalysisHelpPopoverShowing.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(maxWidth: 14, maxHeight: 14)
                                .popover(isPresented: $isAnalysisHelpPopoverShowing,
                                         attachmentAnchor: .point(.top),
                                         arrowEdge: .top,
                                         content: {
                                    VStack {
                                        Text("We use external ai (openai) to analyze")
                                        Text("your writing. This analysis is not an")
                                        Text("official indication of how well you")
                                        Text("write, but a simple prediction based")
                                        Text("on the words the ai models have been trained ")
                                        Text("on. Please do not use our analysis as an")
                                        Text("official metric to judge your writing.")
                                    }
                                    
                                    .multilineTextAlignment(.center)
                                    .lineLimit(0)
                                    //                                .foregroundStyle(.black)
                                    .font(.system(size: 10, weight: .medium, design: .rounded))
                                    .padding()
                                    .presentationCompactAdaptation(.none)
                                })
                        }
                    }
                    
                    
                    // Scoring
                    HStack {
                        // Prose
                        VStack {
                            Text("7.3")
                                .font(.system(size: 24, design: .serif))
                                .bold()
                                .foregroundStyle(Color.green)
                            
                            Text("Prose")
                                .font(.system(size: 14, design: .serif))
                        }
                        // Imagery
                        VStack {
                            Text("3.8")
                                .font(.system(size: 24, design: .serif))
                                .bold()
                                .foregroundStyle(Color.red)
                            
                            Text("Imagery")
                                .font(.system(size: 14, design: .serif))
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        
                        
                        // Flow
                        VStack {
                            Text("6.2")
                                .font(.system(size: 24, design: .serif))
                                .bold()
                                .foregroundStyle(Color.orange)
                            
                            Text("Flow")
                                .font(.system(size: 14, design: .serif))
                        }
                    }
                    .padding(.bottom, 2)
                    
                    // Text Analysis
                    Text("Your response captures the excitement and diversity of the zero-gravity sports tournament, with vivid imagery and engaging descriptions. The narrative flows well, making the scene immersive. However, adding more specific details about the unique skills or appearance of the alien competitors could enhance the richness of the setting. Overall, it's a compelling and concise piece.")
                        .font(.system(size: 15, design: .serif))
                    
                    Text("5.76")
                        .font(.system(size: 28, design: .serif))
                        .bold()
                        .foregroundStyle(Color.orange)
                    
                    
                    Text("Overall")
                        .font(.system(size: 18, design: .serif))
                    
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    HistoryAnalysisView()
}
