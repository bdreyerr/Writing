//
//  ProfileMainView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct ProfileMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var showSidebar: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            
            
            SideBarStack(sidebarWidth: 240, showSidebar: $showSidebar) {
                
                
//                HStack {
//                    // Button Icons
//                    VStack {
//                        Image(systemName: "person.badge.plus")
//                            .font(.title3)
//                        
//                        Image(systemName: "envelope")
//                            .font(.title3)
//                        
//                        Image(systemName: "bolt")
//                            .font(.title3)
//                        
//                        Image(systemName: "gearshape")
//                            .font(.title3)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(5)
//                    // Button Text
//                    VStack {
//                        Text("Edit Profile")
//                            .font(.system(size: 16, design: .serif))
//                        
//                        Text("Suggest a Prompt")
//                            .font(.system(size: 16, design: .serif))
//                        
//                        Text("How we Analyze")
//                            .font(.system(size: 16, design: .serif))
//                        
//                        Text("Settings")
//                            .font(.system(size: 16, design: .serif))
//                    }
//                }
//                .padding(.top, 60)
//                .padding(.leading, 20)
//                .padding(.trailing, 20)
//                .padding(.bottom, 60)
                
                
                VStack {
                    // Edit Profile
                    NavigationLink(destination: ProfileEditProfileView()) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .font(.title3)
                            Text("Edit Profile")
                                .font(.system(size: 16, design: .serif))
                        }
                        .padding(.bottom, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Suggest a Prompt
                    NavigationLink(destination: ProfileSuggestPromptView()) {
                        HStack {
                            Image(systemName: "leaf.circle")
                                .font(.title3)
                            
                            Text("Suggest a Prompt")
                                .font(.system(size: 16, design: .serif))
                        }
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // How we Analyze
                    NavigationLink(destination: ProfileHowWeAnalyzeView()) {
                        HStack {
                            Image(systemName: "bolt")
                                .font(.title3)
                            
                            Text("How we Analyze")
                                .font(.system(size: 16, design: .serif))
                        }
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Settings
                    HStack {
                        Image(systemName: "gearshape")
                            .font(.title3)
                        
                        Text("Settings")
                            .font(.system(size: 16, design: .serif))
                    }
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Button(action: {
                        self.isDarkMode.toggle()
                    }) {
                        Image(systemName: "moon.stars")
                            .font(.title)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 60)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 60)
                
            } content: {
                ZStack {
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                HStack {
                                    // Side Menu activate
                                    Button(action: {
                                        self.showSidebar = true
                                    }) {
                                        Image(systemName: "text.justify")
                                            .font(.title3)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    HStack {
                                        // Share Profile
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.title3)
                                        
                                        // Settings buttons
                                        Image(systemName: "gearshape")
                                            .font(.title3)
                                    }.frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                
                                .padding(.bottom, 10)
                                
                                
                                HStack {
                                    Image("space-guy")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                                        .padding(.trailing, 20)
                                    
                                    HStack {
                                        VStack {
                                            Text("63")
                                                .font(.system(size: 22, design: .serif))
                                            
                                            Text("Shorts")
                                                .font(.system(size: 14, design: .serif))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        
                                        VStack {
                                            Text("1.4k")
                                                .font(.system(size: 22, design: .serif))
                                            
                                            Text("Likes")
                                                .font(.system(size: 14, design: .serif))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        
                                        VStack {
                                            Text("8.1")
                                                .font(.system(size: 22, design: .serif))
                                            
                                            Text("Avg")
                                                .font(.system(size: 14, design: .serif))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        
                                    }
                                    
                                    
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 20)
                                
                                HStack {
                                    Text("Salvor Hardin")
                                        .font(.system(size: 24, design: .serif))
                                        .bold()
                                    
                                    Text(" - 13 Day Streak 🔥")
                                        .font(.system(size: 16, design: .serif))
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                
                                Text("Since Aug 2023")
                                    .font(.system(size: 12, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .opacity(0.7)
                                    .padding(.bottom, 20)
                                
                                
                                // Streaks
                                
                                // Recent Posts
                                
                                HStack {
                                    Text("Your Shorts")
                                        .font(.system(size: 22, design: .serif))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                    //                    Text("Recent")
                                    //                        .font(.system(size: 20, design: .serif))
                                    //                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    //                    Image(systemName: "clock")
                                    //                        .font(.callout)
                                    
                                    HStack {
                                        Menu {
                                            Button("Recent", action: {
                                                return
                                            })
                                            Button("Best", action: {
                                                return
                                            })
                                        } label: {
                                            HStack {
                                                Text("Recent")
                                                    .font(.system(size: 13, design: .serif))
                                                
                                                Image(systemName: "clock")
                                                    .font(.subheadline)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            
                            VStack(spacing: 0.5) {
                                HStack(spacing: 0.5) {
                                    ResponsePreview(promptImage: "prompt1", date: "6.7.24")
                                    ResponsePreview(promptImage: "prompt2", date: "6.1.24")
                                    ResponsePreview(promptImage: "prompt5", date: "6.1.24")
                                }
                                
                                HStack(spacing: 0.5) {
                                    ResponsePreview(promptImage: "prompt3", date: "5.27.24")
                                    ResponsePreview(promptImage: "prompt4", date: "4.28.24")
                                    ResponsePreview(promptImage: "prompt6", date: "4.28.24")
                                }
                                HStack(spacing: 0.5) {
                                    ResponsePreview(promptImage: "prompt5", date: "4.13.24")
                                    ResponsePreview(promptImage: "prompt6", date: "4.07.24")
                                    ResponsePreview(promptImage: "prompt2", date: "4.07.24")
                                }
                            }
                            
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
                                
                                Text("Promptly")
                                    .font(.system(size: 15, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .bottom)
                                    .opacity(0.8)
                                Text("version 1.1 june 2024")
                                    .font(.system(size: 11, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .bottom)
                                    .opacity(0.8)
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ProfileMainView()
}


struct ResponsePreview: View {
    
    var promptImage: String
    var date: String
    @State private var isSinglePersonalResponsePopupShowing: Bool = false
    
    var body: some View {
        Button(action: {
            self.isSinglePersonalResponsePopupShowing.toggle()
        }) {
            ZStack(alignment: .topTrailing) {
                Image(promptImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 400, maxHeight: 300)
                
                VStack {
                    HStack {
                        RoundedRectangle(cornerRadius: 30.0)
                            .frame(width: 50, height: 20)
                            .foregroundStyle(Color.black)
                            .opacity(0.6)
                        
                            .overlay {
                                Text(date)
                                    .font(.system(size: 11, design: .serif))
                                    .foregroundStyle(Color.white)
                            }
                    }
                }
                .padding(8)
            }
        }
        .sheet(isPresented: $isSinglePersonalResponsePopupShowing) {
            SinglePersonalResponse(imageName: "space-guy", authorHandle: "Salvor Hardin", timePosted: "3:23pm", prompt: "The inconcievable universe seemed increddibly large for almost all of it's inhabitants. Except for Jackal Lend, maybe one of the only men in the Universe who truly understood its scale.", response: "Jackal Lend stood on the bridge of his starship, gazing out at the swirling galaxies beyond. To most, the cosmos was an endless expanse of mystery and wonder. But to Jackal, it was a map he had memorized long ago. He had traveled to the furthest reaches, seen stars born and die, and navigated the black holes' perilous edges. The universe’s vastness was no longer daunting; it was a puzzle he had pieced together, every fragment a testament to his relentless exploration. For Jackal Lend, the universe wasn't vast; it was home.", numLikes: 42, numComments: 13)
        }
    }
}
