//
//  ProfileSettingsView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/10/24.
//

import SwiftUI

struct ProfileSettingsView: View {
    @AppStorage("filterNSFWShorts") private var filterNSFWShorts = false
    
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var profileController: ProfileController
    
    @State var isConfirmDeleteAccountAlertShowing: Bool = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("The Daily Short")) {
                    Link("Terms of Use (EULA)", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    
                    Link("Privacy Policy", destination: URL(string: "https://sites.google.com/view/the-daily-short-privacy-policy/home")!)
                    
                    Toggle(isOn: $filterNSFWShorts) {
                        Text("Filter NSFW Content")
                    }
                }
                
                
                if let user = userController.user {
                    Section(header: Text("Account")) {
                        Button(action: {
                            // Sign out of account - auth
                            authController.logOut()
                            // Set the user back to nil
                            userController.logOut()
                            // reset the shorts on home screen
                            homeController.clearShortOnSignOut()
                            // reset the shorts on profile screen
                            profileController.clearShorts()
                            // dismiss the settings sheet
                            profileController.isSettingsShowing = false
                        }) {
                            Text("Sign Out")
                        }
                        
                        Button(action: {
                            self.isConfirmDeleteAccountAlertShowing = true
                            
                            
                        }) {
                            Text("Delete Account")
                                .foregroundColor(.red)
                        }
                        .alert("Are you sure?", isPresented: $isConfirmDeleteAccountAlertShowing) {
                            Button("Confirm") {
                                Task {
                                    // delete local user
                                    userController.deleteUser()
                                    // delete auth
                                    authController.deleteAuthUser()
                                    //                                // Log out - auth
                                    //                                authController.logOut()
                                    //                                // log out - local
                                    //                                userController.logOut()
                                    // reset the shorts on home screen
                                    DispatchQueue.main.async {
                                        homeController.clearShortOnSignOut()
                                        // dismiss the settings sheet
                                        profileController.isSettingsShowing = false
                                    }
                                }
                            }
                            
                            Button("Cancel", role: .cancel) { }
                        }
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
