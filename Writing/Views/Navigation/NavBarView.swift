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
            HomeMainView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            HistorySingleResponseView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
    }
}

#Preview {
    NavBarView()
}
