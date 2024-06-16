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
            if self.isSignedIn == false {
                ProfileMainViewNotSignedIn()
            } else {
                ProfileMainView()
            }
        }
    }
}

#Preview {
    ProfileContentView()
}
