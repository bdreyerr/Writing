//
//  HistorySingleResponseView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct HistorySingleResponseView: View {
    @State private var date = Date()
    var body: some View {
        ZStack {
            VStack {
                // Date
                HStack {
                    // Date label
                    VStack {
                        Text("December 24th 2024")
                            .font(.system(size: 14, design: .serif))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    // Calendar Picker
                    Image(systemName: "calendar")
                        .font(.title3)
                        .overlay {
                            DatePicker("", selection: $date, displayedComponents: [.date]
                            )
                            .blendMode(.destinationOver)
                            .frame(maxWidth: 40, maxHeight: 40)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 10)
//                .padding(.leading, 20)
//                .padding(.trailing, 20)
                .padding(.bottom, 20)
                
                
                // Prompt Image
                Image("floating")
                    .resizable()
                    .frame(maxWidth: 400, maxHeight: 300)
                    
                
                VStack {
                    // Prompt
                    Text("In the 45th century, Earth's greatest athletes compete in a zero-gravity sports tournament, where interstellar species vie for the ultimate championship.")
                        .font(.system(size: 14, design: .serif))
                        .italic()
                        .padding(.bottom, 20)
                    
                    // Your Response
                    ScrollView(showsIndicators: false) {
                        Text("In the sprawling arena orbiting Earth, athletes from across the galaxy floated in zero-gravity, poised for the ultimate showdown. Representing diverse planets, their bodies adapted to unique environments, each competitor brought unparalleled skills and strategies. The crowd, an interstellar mix, watched in awe as the tournament began. Kira, Earth's champion, twisted mid-air, executing moves impossible under gravity's pull. Her opponent, a Martian with enhanced reflexes, countered with lightning speed. The clash was a breathtaking dance of agility and precision, a testament to human evolution and extraterrestrial prowess. As Kira scored the winning point, cheers erupted, echoing through the cosmos.")
                            .font(.system(size: 13, design: .serif))
                    }
                    
                    
                    HStack {
                        // Edit Your Response
                        Image(systemName: "square.and.pencil")
                            .font(.title)
                            .foregroundStyle(Color.yellow)
                        
                        // View Writing Analysis
                        Image(systemName: "bolt.circle")
                            .font(.title)
                            .foregroundStyle(Color.blue)
                    }
                    
                }
//                .padding(.leading, 20)
//                .padding(.trailing, 20)
                .padding(.top, 15)
                
                
                
                
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
        }
    }
}

#Preview {
    HistorySingleResponseView()
}
