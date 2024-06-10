//
//  NavBarView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/4/24.
//

import SwiftUI

struct NavBarView: View {
    var body: some View {
        TabView {
            Group {
                HomeMainView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                ProfileMainView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
            
        }
    }
}

#Preview {
    NavBarView()
}
