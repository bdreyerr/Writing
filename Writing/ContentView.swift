//
//  ContentView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authController = AuthController()
    @StateObject var homeController = HomeController()
    @StateObject var userController = UserController()
    @StateObject var profileController = ProfileController()
    var body: some View {
        
        ZStack {
            NavBarView()
        }
        .environmentObject(authController)
        .environmentObject(homeController)
        .environmentObject(userController)
        .environmentObject(profileController)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthController())
        .environmentObject(HomeController())
        .environmentObject(UserController())
        .environmentObject(ProfileController())
}
