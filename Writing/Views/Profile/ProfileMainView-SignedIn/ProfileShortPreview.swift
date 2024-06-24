//
//  ProfileShortPreview.swift
//  Writing
//
//  Created by Ben Dreyer on 6/23/24.
//

import FirebaseFirestore
import SwiftUI

struct ProfileShortPreview: View {
    @EnvironmentObject var profileController: ProfileController
    
    var short: Short
    var image: UIImage
    
    var body: some View {
        Button(action: {
            // focus a single short
            profileController.focusShort(short: self.short)
        }) {
            VStack {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .clipped()
                        .aspectRatio(1, contentMode: .fit)
                    
                    VStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 30.0)
                                .frame(width: 100, height: 20)
                                .foregroundStyle(Color.black)
                                .opacity(0.6)
                            
                                .overlay {
                                    Text(profileController.convertDateString(intDateString: short.date!))
                                        .font(.system(size: 11, design: .serif))
                                        .foregroundStyle(Color.white)
                                }
                        }
                    }
                    .padding(8)
                }
            }
        }
    }
}

#Preview {
    ProfileShortPreview(short: Short(date: "20240620", rawTimestamp: Timestamp(), shortRawText: "this the prompt"), image: UIImage(named: "wolf")!)
        .environmentObject(ProfileController())
}
