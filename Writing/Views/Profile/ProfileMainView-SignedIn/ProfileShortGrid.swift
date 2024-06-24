//
//  ProfileShortGrid.swift
//  Writing
//
//  Created by Ben Dreyer on 6/23/24.
//

import SwiftUI

struct ProfileShortGrid: View {
    @EnvironmentObject var profileController: ProfileController
    
    var body: some View {
        VStack(spacing: 0.5) {
            ForEach(profileController.chunksOfShorts) { chunk in
                HStack(spacing: 0.5) {
                    ForEach(chunk.shorts) { short in
                        // check the image exists
                        if let image = profileController.promptImages[short.date!] {
                            ProfileShortPreview(short: short, image: image)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileShortGrid()
        .environmentObject(ProfileController())
}
