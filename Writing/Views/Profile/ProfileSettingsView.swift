//
//  ProfileSettingsView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/10/24.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @EnvironmentObject var authController: AuthController
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Dreamrs")) {
                    Link("Terms of Use (EULA)", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    
                    Link("Privacy Policy", destination: URL(string: "https://sites.google.com/view/dreamboard-privacy-policy/home")!)
                }
                
                Section(header: Text("Account")) {
                    Button(action: {
                        // Sign out of account
                        authController.logOut()
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
}
