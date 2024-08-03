//
//  WritingApp.swift
//  Writing
//
//  Created by Ben Dreyer on 6/1/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}


@main
struct WritingApp: App {
    // App Storage: isDarkMode variable tracks dark theme throughout the app
    @AppStorage("isDarkMode") private var isDarkMode = false
    // App Storage: isSignedIn tracks auth status throughout app
    @AppStorage("isSignedIn") private var isSignedIn = false
    // App Storage: isTabBarShowing tracks if the tab bar should be visible or not
    @AppStorage("isTabBarShowing") private var isTabBarShowing = true
    // App Storage: Var for deciding whether notification cadence is daily or weekly
    @AppStorage("isNotificationDaily") private var notificationCadence = true
    // App Storage: Time of day for the notification to fire (converted into string from Date Object)
    @AppStorage("notificationTimeOfDay") private var notificationTimeOfDay = ""
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onAppear {
                    self.isTabBarShowing = true
                }
        }
    }
}
