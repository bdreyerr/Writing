//
//  ProfileMainView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/3/24.
//

import SwiftUI

struct ProfileMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        NavigationView {
            ZStack {
                SideBarStack(sidebarWidth: 240, showSidebar: $profileController.showSidebar) {
                    ProfileSidebarContentView()
                } content: {
                    VStack {
                        HStack {
                            HStack {
                                Button(action: {
                                    profileController.showSidebar = true
                                }) {
                                    Image(systemName: "text.justify")
                                        .font(.title3)
                                        
                                }
                                .buttonStyle(PlainButtonStyle())
                                
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
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            // Side Menu activate
                            
                            
                            HStack {
                                // Share Profile
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                
                                // Settings buttons
                                Button(action: {
                                    profileController.isSettingsShowing = true
                                }) {
                                    Image(systemName: "gearshape")
                                        .font(.title3)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
//                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                        }
                        .padding(.top, 15)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.bottom, 10)
                        
                        ScrollView(showsIndicators: false) {
                            VStack {
                                HStack {
                                    VStack {
                                        if let image = userController.usersProfilePicture {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(maxWidth: 60, maxHeight: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        } else {
                                            Image("not-signed-in-profile")
                                                .resizable()
                                                .frame(maxWidth: 60, maxHeight: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        if let user = userController.user {
                                            Text(user.firstName! + " " + user.lastName!)
                                                .font(.system(size: 16, design: .serif))
                                                .bold()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        } else {
                                            Text("Guest Writer")
                                                .font(.system(size: 16, design: .serif))
                                                .bold()
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        
                                        // Profile Title
                                        if let user = userController.user {
                                            Text(profileController.convertTitleIntToString(int: user.title ?? 0))
                                                .font(.system(size: 12, design: .serif))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .opacity(0.7)
                                        } else {
                                            Text("Novice Author")
                                                .font(.system(size: 12, design: .serif))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .opacity(0.7)
                                        }
                                        
                                    }
                                    .frame(minWidth: 100, maxWidth: 140, alignment: .leading)
                                    
                                    
                                    HStack {
                                        if let user = userController.user {
                                            VStack {
                                                Text("\(user.shortsCount!.formatted())")
                                                    .font(.system(size: 16, design: .serif))
                                                
                                                Text("Shorts")
                                                    .font(.system(size: 10, design: .serif))
                                            }
                                            .padding()
                                            
                                            VStack {
                                                Text("\(user.numLikes!.formatted())")
                                                    .font(.system(size: 16, design: .serif))
                                                
                                                Text("Likes")
                                                    .font(.system(size: 10, design: .serif))
                                            }
                                            .padding()
                                            
                                            VStack {
                                                Text(String(format: "%.1f", user.avgWritingScore ?? 0.0))
                                                    .font(.system(size: 16, design: .serif))
                                                
                                                Text("Avg")
                                                    .font(.system(size: 10, design: .serif))
                                            }
                                            .padding()
                                        } else {
                                            VStack {
                                                Text("0")
                                                    .font(.system(size: 16, design: .serif))
                                                
                                                Text("Shorts")
                                                    .font(.system(size: 10, design: .serif))
                                            }
                                            .padding()
                                            VStack {
                                                Text("0")
                                                    .font(.system(size: 16, design: .serif))
                                                
                                                Text("Likes")
                                                    .font(.system(size: 10, design: .serif))
                                            }
                                            .padding()
                                            VStack {
                                                Text("0")
                                                    .font(.system(size: 16, design: .serif))
                                                
                                                Text("Avg")
                                                    .font(.system(size: 10, design: .serif))
                                            }
                                            .padding()
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 20)
                                
                                
                                NavigationLink(destination: ProfileStreaksAndAwardsView()) {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(lineWidth: 1)
                                        .frame(width: 150, height: 40)
                                        .overlay {
                                            HStack {
                                                // TODO(bendreyer): have a couple different openers here (start your creation, dive right in, etc..) and pick one at random
                                                Text("Streaks & Awards")
                                                    .font(.system(size: 12, design: .serif))
    //                                                .bold()
                                                
                                                Image(systemName: "trophy")
                                                
                                            }
                                        }
                                        .padding(.bottom, 10)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(PlainButtonStyle())
                               
                                
                                
                                
                                // Your Shorts
                                HStack {
                                    Text("Your Shorts")
                                        .bold()
                                        .font(.system(size: 16, design: .serif))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack {
                                        Menu {
                                            Button(action: {
                                                profileController.sortShorts(byDateWritten: true, byNumLikes: false, byPromptDate: false)
                                            }) {
                                                HStack {
                                                    Text("Recent")
                                                        .font(.system(size: 13, design: .serif))
                                                    
                                                    Image(systemName: "clock")
                                                        .font(.subheadline)
                                                }
                                                
                                            }
                                            Button(action: {
                                                profileController.sortShorts(byDateWritten: false, byNumLikes: true, byPromptDate: false)
                                            }) {
                                                HStack {
                                                    Text("Best")
                                                        .font(.system(size: 13, design: .serif))
                                                    
                                                    Image(systemName: "crown")
                                                        .font(.subheadline)
                                                }
                                            }
                                            Button(action: {
                                                profileController.sortShorts(byDateWritten: false, byNumLikes: false, byPromptDate: true)
                                            }) {
                                                HStack {
                                                    Text("Prompt Date")
                                                        .font(.system(size: 13, design: .serif))
                                                    
                                                    Image(systemName: "calendar.circle")
                                                        .font(.subheadline)
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                if profileController.shortsSortingMethod == 0 {
                                                    Text("Recent")
                                                        .font(.system(size: 13, design: .serif))
                                                } else if profileController.shortsSortingMethod == 1 {
                                                    Text("Best")
                                                        .font(.system(size: 13, design: .serif))
                                                } else if profileController.shortsSortingMethod == 2 {
                                                    Text("Prompt date")
                                                        .font(.system(size: 13, design: .serif))
                                                }
                                                
                                                Image(systemName: "chevron.down")
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
                            
                            
                            ProfileShortGrid()
                            
                            
                            // Pagination control (for now it's just one button that loads older posts)
                            
                            if !profileController.areNoShortsLeftToLoad {
                                Button(action: {
                                    profileController.retrieveNextShorts()
                                }) {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(lineWidth: 1)
                                        .frame(width: 110, height: 35)
                                        .overlay {
                                            HStack {
                                                Text("Older")
                                                    .font(.system(size: 14, design: .serif))
                                                    .bold()
                                                
                                                Image(systemName: "arrow.down")
                                                    .resizable()
                                                    .frame(width: 10, height: 10)
                                            }
                                        }
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                }
                                .buttonStyle(PlainButtonStyle())
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
                                
                                Text("The Daily Short")
                                    .font(.system(size: 15, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .bottom)
                                    .opacity(0.8)
                                Text("version 1.1 june 2024")
                                    .font(.system(size: 11, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .bottom)
                                    .opacity(0.8)
                            }
                            //                            .padding(.top, 50)
                        }
                        .sheet(isPresented: $profileController.isSettingsShowing) {
                            ProfileSettingsView()
                        }
                        .sheet(isPresented: $profileController.isFocusedShortSheetShowing) {
                            ProfileFocusedShortView()
                        }
                        .blur(radius: profileController.showSidebar ? 4.0 : 0.0)
                    }
                }
            }
            .padding(.bottom, 25)
        }
    }
}

#Preview {
    ProfileMainView()
        .environmentObject(ProfileController())
        .environmentObject(UserController())
}


//struct ResponsePreview: View {
//    
//    var promptImage: String
//    var date: String
//    @State private var isSinglePersonalResponsePopupShowing: Bool = false
//    
//    var body: some View {
//        Button(action: {
//            self.isSinglePersonalResponsePopupShowing.toggle()
//        }) {
//            ZStack(alignment: .topTrailing) {
//                Image(promptImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(maxWidth: 400, maxHeight: 300)
//                
//                VStack {
//                    HStack {
//                        RoundedRectangle(cornerRadius: 30.0)
//                            .frame(width: 50, height: 20)
//                            .foregroundStyle(Color.black)
//                            .opacity(0.6)
//                        
//                            .overlay {
//                                Text(date)
//                                    .font(.system(size: 11, design: .serif))
//                                    .foregroundStyle(Color.white)
//                            }
//                    }
//                }
//                .padding(8)
//            }
//        }
//        .sheet(isPresented: $isSinglePersonalResponsePopupShowing) {
//            SinglePersonalResponse(imageName: "space-guy", authorHandle: "Salvor Hardin", timePosted: "3:23pm", prompt: "The inconcievable universe seemed increddibly large for almost all of it's inhabitants. Except for Jackal Lend, maybe one of the only men in the Universe who truly understood its scale.", response: "Jackal Lend stood on the bridge of his starship, gazing out at the swirling galaxies beyond. To most, the cosmos was an endless expanse of mystery and wonder. But to Jackal, it was a map he had memorized long ago. He had traveled to the furthest reaches, seen stars born and die, and navigated the black holes' perilous edges. The universe’s vastness was no longer daunting; it was a puzzle he had pieced together, every fragment a testament to his relentless exploration. For Jackal Lend, the universe wasn't vast; it was home.", numLikes: 42, numComments: 13)
//        }
//    }
//}

extension Int {
    func formatted() -> String {
        if self >= 1000 && self < 10000 {
            return String(format: "%.1fk", Double(self) / 1000.0)
        } else if self >= 10000 && self < 100000 {
            return String(format: "%.0fk", Double(self) / 1000.0)
        } else if self >= 100000 && self < 1000000 {
            return String(format: "%.0fk", Double(self) / 1000.0)
        } else {
            return String(self)
        }
        
    }
}
