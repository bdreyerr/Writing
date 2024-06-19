//
//  FreeWriteContentView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/17/24.
//

import SwiftUI

struct FreeWriteContentView: View {
    
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    var body: some View {
        ZStack {
            FreeWriteSignedOutView()
                .opacity(isSignedIn ? 0.0 : 1.0)
            FreeWriteMainView()
                .opacity(isSignedIn ? 1.0 : 0.0)
        }
    }
}

#Preview {
    FreeWriteContentView()
}
