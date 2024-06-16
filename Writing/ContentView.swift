//
//  ContentView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/1/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authController = AuthController()
    var body: some View {
        
        ZStack {
            NavBarView()
        }
        .environmentObject(authController)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthController())
}
