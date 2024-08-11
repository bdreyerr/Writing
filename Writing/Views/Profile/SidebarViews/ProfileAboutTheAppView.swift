//
//  ProfileAboutTheAppView.swift
//  Writing
//
//  Created by Ben Dreyer on 8/11/24.
//

import SwiftUI

struct ProfileAboutTheAppView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            
            // Logo
            if (colorScheme == .light) {
                Image("LogoTransparentWhiteBackground")
                    .resizable()
                    .frame(width: 80, height: 80)
            } else if (colorScheme == .dark) {
                Image("LogoBlackBackground")
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            Text("The Daily Short")
                .font(.system(size: 15, design: .serif))
                .frame(maxWidth: .infinity, alignment: .bottom)
                .opacity(0.8)
                .padding(.bottom, 20)

            
            Text("Hello! My name is Ben, I'm a developer based in San Francisco, California, and I'm the creator of The Daily Short! I still work full time as a Software Engineer for my day job, but in my spare time I love working on passion projects and apps. I'm hoping to support and keep this app up and running for as long as I can.")
                .font(.system(size: 16, design: .serif))
                .italic()
                .padding(.bottom, 20)
            
            Text("I hope this apps pushes you to stay consistent with your writing journey and helps you find some inspiration among other authors. If you have any suggestions or advice please don't hesistate to send me an email :) - benjaminpbrother@gmail.com")
                .font(.system(size: 16, design: .serif))
                .italic()
                .padding(.bottom, 20)
            
            
            VStack {
                Text("Enjoying the App?")
                    .font(.system(size: 16, design: .serif))
                    .italic()
                    .bold()
                Text("If you'd like to support my work and help keep the app running smoothly, consider buying me a coffee! ☕️ Your support means a lot and helps me continue improving the app for everyone. Tap the button below.")
                    .font(.system(size: 16, design: .serif))
                    .italic()
            }
            
            Button(action: {
                if let url = URL(string: "https://buymeacoffee.com/bendreyer") {
                    UIApplication.shared.open(url)
                }
            }) {
                Image("bmc-button")
                    .resizable() // Make the image resizable
                    .scaledToFill() // Scale the image to fill the space
                    .frame(width: 200, height: 50) // Set the size of the image
                    .clipped() // Clip the overflowing parts of the image
                    .cornerRadius(20) // Apply corner radius to the image
            }
            
            Spacer()
        }
        .padding(.top, 40)
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

#Preview {
    ProfileAboutTheAppView()
}
