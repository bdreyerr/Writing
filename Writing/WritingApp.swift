//
//  WritingApp.swift
//  Writing
//
//  Created by Ben Dreyer on 6/1/24.
//

import SwiftUI

@main
struct WritingApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
