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
    var body: some View {
        
        ZStack {
            NavBarView()
        }
        .environmentObject(authController)
        .environmentObject(homeController)
        .environmentObject(userController)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthController())
        .environmentObject(HomeController())
        .environmentObject(UserController())
}
