//
//  ProfileSuggestPromptView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/9/24.
//

import SwiftUI

struct ProfileSuggestPromptView: View {
    @State private var suggestedPromptText: String = ""
    var body: some View {
        VStack {
            Text("Our app thrives on community suggested prompts, if you think you have a great idea and want others to write about it, please submit it here!")
                .font(.system(size: 16, design: .serif))
                .italic()
            
            TextField("In a far away land...",text: $suggestedPromptText, axis: .vertical)
//                .modifier(KeyboardAdaptive())
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
                Text("\(self.suggestedPromptText.count) / 200 Characters")
                    .font(.system(size: 12, design: .serif))
                
                Image(systemName: "arrowshape.right.circle")
                    .font(.callout)
                    .foregroundStyle(Color.green)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.leading, 20)
        .padding(.trailing, 20)
        
    }
}

#Preview {
    ProfileSuggestPromptView()
}
