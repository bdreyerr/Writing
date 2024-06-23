//
//  ProfileSidebarContentView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/22/24.
//

import SwiftUI

struct ProfileSidebarContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @EnvironmentObject var profileController: ProfileController
    var body: some View {
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
            
            // How we Analyze
            NavigationLink(destination: ProfileHowWeAnalyzeView()) {
                HStack {
                    Image(systemName: "chart.bar.xaxis.ascending")
                        .font(.title3)
                    
                    Text("Advertise with Us")
                        .font(.system(size: 16, design: .serif))
                }
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Settings
            Button(action: {
                profileController.isSettingsShowing = true
            }) {
                HStack {
                    Image(systemName: "gearshape")
                        .font(.title3)
                    
                    Text("Settings")
                        .font(.system(size: 16, design: .serif))
                }
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
            
            
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
    }
}

#Preview {
    ProfileSidebarContentView()
        .environmentObject(ProfileController())
}
