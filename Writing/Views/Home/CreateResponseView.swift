//
//  CreateResponseView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct CreateResponseView: View {
    
    @State private var response: String = ""
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                TodaysPrompt(image: "prompt-knight", prompt: "A seasoned knight and his loyal squire discover the scene of a crime. They find a ransacked carriage and dwarf who cannot walk. They discuss what action to take next.", tags: ["Fantasy", "ThronesLike"], likeCount: 173, responseCount: 47, includeResponseCount: true)
                
                // TODO(bendreyer): have a couple different openers here (once upon a time, in a land far far away, etc..) and pick one at random
                TextField("Once upon a time...",text: $response, axis: .vertical)
//                    .modifier(KeyboardAdaptive())
                    .font(.system(size: 16, design: .serif))
                // Styling
                    .padding(.vertical, 8)
                    .background(
                        VStack {
                            Spacer()
                            Color(UIColor.systemGray4)
                                .frame(height: 2)
                        }
                    )
                HStack {
                    // Character Count
                    Text("\(self.response.count) / 1500 Characters")
                        .font(.system(size: 12, design: .serif))
                    
                    Image(systemName: "arrowshape.right.circle")
                        .font(.callout)
                        .foregroundStyle(Color.green)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Spacer()
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        
    }
}

#Preview {
    CreateResponseView()
}
