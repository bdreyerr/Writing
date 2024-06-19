//
//  FreeWriteSingleEntryView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/16/24.
//

import SwiftUI

struct FreeWriteSingleEntryView: View {
    
    var profilePicture: String
    var authorHandle: String
    var title: String
    var content: String
    var icon: String
    
    var body: some View {
        VStack {
            HStack {
                // Profile Picture
                Image(profilePicture)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                
                
                VStack {
                    // Handle
                    Text(title)
                        .font(.system(size: 12, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Date posted
                    Text(authorHandle)
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: icon)
                    .font(.headline)
            }
            .padding(.bottom, 10)
            ScrollView(showsIndicators: false) {
                
                Text(content)
                    .font(.system(size: 16, design: .serif))
            }
        }
        .padding(.top, 20)
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

#Preview {
    FreeWriteSingleEntryView(profilePicture: "wolf", authorHandle: "Salvor Hardin", title: "The Battle of Hardholm", content: "The air was ice. Fifty feet across the water Jon saw death. Thousands of dead men, women and children staring soullessly across the lake at Jon and his men. The stench hit him first. A tide of decay washing over them, thick and cloying. It was the smell of hopelessness, of a battle long since lost.\n\nJon tightened his grip on his sword, the leather slick beneath his sweating palms. He could hear the ragged gasps of his men, the fear a palpable presence in the thin air. A raven circled overhead, its harsh caw echoing across the desolate landscape. Jon shivered, not just from the cold, but from a deeper dread that gnawed at him. How many lives had been lost here, defending this forgotten corner of the world? And for what? The dead offered no answers, only a silent accusation.", icon: "sun.max")
}
