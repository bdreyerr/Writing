//
//  ProfileSettingsView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/10/24.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var profileController: ProfileController
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Dreamrs")) {
                    Link("Terms of Use (EULA)", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    
                    Link("Privacy Policy", destination: URL(string: "https://sites.google.com/view/dreamboard-privacy-policy/home")!)
                }
                
                Section(header: Text("Account")) {
                    Button(action: {
                        // Sign out of account - auth
                        authController.logOut()
                        // Set the user back to nil
                        userController.logOut()
                        // reset the shorts on home screen
                        homeController.clearShortOnSignOut()
                        // dismiss the settings sheet
                        profileController.isSettingsShowing = false
                    }) {
                        Text("Sign Out")
                    }
                    
                    Button(action: {
//                        self.confirmDelete = true
                    }) {
                        Text("Delete Account")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileSettingsView()
        .environmentObject(AuthController())
        .environmentObject(UserController())
        .environmentObject(HomeController())
        .environmentObject(ProfileController())
}
