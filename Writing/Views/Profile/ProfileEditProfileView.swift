//
//  ProfileEditProfileView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/9/24.
//

import SwiftUI

struct ProfileEditProfileView: View {
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        
                    }) {
                        Image("space-guy")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "pencil.circle.fill")
                                    .font(.system(size: 30))
                                .padding(-12)
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 25)
                    
                    Text("Salvor Hardin")
                        .font(.system(size: 24, design: .serif))
                        .bold()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                    }
                    
                }
                Spacer()
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    ProfileEditProfileView()
}
