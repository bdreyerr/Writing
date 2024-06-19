//
//  FreeWriteMainView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/16/24.
//

import SwiftUI

struct FreeWriteMainView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Logo / Slogan / Free Write
                    HStack {
                        // Small Logo
                        if (colorScheme == .light) {
                            Image("LogoTransparentWhiteBackground")
                                .resizable()
                                .frame(width: 30, height: 30)
                        } else if (colorScheme == .dark) {
                            Image("LogoBlackBackground")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                        Text("| The Daily Short")
                            .font(.system(size: 16, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                        
                        Text("Free Write")
                            .font(.system(size: 16, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .bold()
                    }
                    .padding(.top, 15)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            
                            // Writing Stats
                            HStack {
                                VStack {
                                    Text("14")
                                        .font(.system(size: 20, design: .serif))
                                    
                                    Text("Entries")
                                        .font(.system(size: 12, design: .serif))
                                }
                                .padding()
                                
                                VStack {
                                    Text("105")
                                        .font(.system(size: 20, design: .serif))
                                    
                                    Text("Avg Word Count")
                                        .font(.system(size: 12, design: .serif))
                                }
                                .padding()
                            }
                            
                            HStack {
                                Text("Latest Entries")
                                    .font(.system(size: 16, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                
                                Text("View All")
                                    .font(.system(size: 12, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.bottom, 10)
                            
                            EntryPreview(date: Date(), title: "Poetry 34", numWords: 144, icon: "sun.max")
                            
                            EntryPreview(date: Date() - 144123123, title: "I Love him not", numWords: 34, icon: "figure.fishing")
                            
                            EntryPreview(date: Date() - 123123123, title: "The whisper", numWords: 204, icon: "flag.checkered")
                            
                            EntryPreview(date: Date() - 13132, title: "That evening of torture", numWords: 12, icon: "volleyball")
                            
                            NavigationLink(destination: FreeWriteCreateEntryView()) {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 220, height: 40)
                                    .overlay {
                                        HStack {
                                            // TODO(bendreyer): have a couple different openers here (start your creation, dive right in, etc..) and pick one at random
                                            Text("In a land far far away...")
                                                .font(.system(size: 14, design: .serif))
                                                .bold()
                                            
                                            Image(systemName: "plus.circle")
                                            
                                        }
                                    }
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            VStack {
                                // Logo
                                if (colorScheme == .light) {
                                    Image("LogoTransparentWhiteBackground")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                } else if (colorScheme == .dark) {
                                    Image("LogoBlackBackground")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                }
                                
                                Text("The Daily Short")
                                    .font(.system(size: 15, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .bottom)
                                    .opacity(0.8)
                                Text("version 1.1 june 2024")
                                    .font(.system(size: 11, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .bottom)
                                    .opacity(0.8)
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }
                }
            }
            .padding(.bottom, 25)
        }
    }
}

#Preview {
    FreeWriteMainView()
}

struct EntryPreview : View {
    
    var date: Date
    var title: String
    var numWords: Int
    var icon: String
    
    let calendar = Calendar.current
    
    var body: some View {
        NavigationLink(destination: FreeWriteSingleEntryView(profilePicture: "wolf", authorHandle: "Salvor Hardin", title: "The Battle of Hardholm", content: "The air was ice. Fifty feet across the water Jon saw death. Thousands of dead men, women and children staring soullessly across the lake at Jon and his men. The stench hit him first. A tide of decay washing over them, thick and cloying. It was the smell of hopelessness, of a battle long since lost.\n\nJon tightened his grip on his sword, the leather slick beneath his sweating palms. He could hear the ragged gasps of his men, the fear a palpable presence in the thin air. A raven circled overhead, its harsh caw echoing across the desolate landscape. Jon shivered, not just from the cold, but from a deeper dread that gnawed at him. How many lives had been lost here, defending this forgotten corner of the world? And for what? The dead offered no answers, only a silent accusation.", icon: "sun.max")) {
            VStack {
                HStack {
                    VStack {
                        Text("\(calendar.component(.day, from: date))")
                            .font(.system(size: 18, design: .serif))
                        
                        Text("Jun")
                            .font(.system(size: 12, design: .serif))
                    }
                    
                    
                    Text("|")
                        .font(.system(size: 25, design: .serif))
                    
                    VStack {
                        Text(title)
                            .font(.system(size: 18, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Text("Last Updated \(date.formatted(date: .omitted, time: .shortened))")
                                .font(.system(size: 12, design: .serif))
                            
                            Text("●")
                                .font(.system(size: 12, design: .serif))
                            
                            Text("\(numWords) words")
                                .font(.system(size: 12, design: .serif))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Image(systemName: icon)
                        .font(.headline)
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
