//
//  ContentView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/1/24.
//

import FirebaseAuth
import SwiftUI

struct ContentView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @StateObject var authController = AuthController()
    @StateObject var homeController = HomeController()
    @StateObject var userController = UserController()
    @StateObject var profileController = ProfileController()
    @StateObject var localNotificationController = LocalNotificationController()
    
    // Scene phase (used for tracking when notification auth status changes)
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        ZStack {
            NavBarView()
        }
        .environmentObject(authController)
        .environmentObject(homeController)
        .environmentObject(userController)
        .environmentObject(profileController)
        .environmentObject(localNotificationController)
        .task {
            try? await localNotificationController.requestAuthorization()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                Task {
                    await localNotificationController.getCurrentSetting()
                    await localNotificationController.getPendingRequests()
                    if localNotificationController.isGranted {
                        localNotificationController.enableNotifications()
                    }
                }
            }
        }
        .onChange(of: isSignedIn) {
            print("is Signed in value has changed: ", isSignedIn)
            
            if isSignedIn == true {
                if let user = Auth.auth().currentUser {
                    print("YAY called retrieve user on dissapear auth view")
                    userController.retrieveUserFromFirestore(userId: user.uid)
                    userController.retrieveUsersProfilePicture(userId: user.uid)
                    profileController.retrieveShorts()
                } else {
                    print("no auth user yet lol nice try")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthController())
        .environmentObject(HomeController())
        .environmentObject(UserController())
        .environmentObject(ProfileController())
        .environmentObject(LocalNotificationController())
}
