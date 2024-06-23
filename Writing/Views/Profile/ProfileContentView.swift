//
//  ProfileContentView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/15/24.
//

import SwiftUI

struct ProfileContentView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    var body: some View {
        ZStack {
            ProfileMainViewNotSignedIn()
                .opacity(isSignedIn ? 0.0 : 1.0)
            ProfileMainView()
                .opacity(isSignedIn ? 1.0 : 0.0)
        }
    }
}

#Preview {
    ProfileContentView()
}
