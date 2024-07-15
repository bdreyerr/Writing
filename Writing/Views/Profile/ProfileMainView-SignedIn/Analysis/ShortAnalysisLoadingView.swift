//
//  ShortAnalysisLoadingView.swift
//  Writing
//
//  Created by Ben Dreyer on 7/15/24.
//

import SwiftUI

struct ShortAnalysisLoadingView: View {
    @EnvironmentObject var shortAnalysisController: ShortAnalysisController
    
    // Animation vars
    @State var imageScale: CGFloat = 1.0
    @State var imageOpacity: Double = 1.0
    
    var body: some View {
        VStack {
            if !shortAnalysisController.isErrorLoadingAnalysis {
                Text("Generating Your Analysis...")
                    .font(.system(size: 16, design: .serif))
                    .italic()
                    .bold()
                    .foregroundStyle(Color.blue)
                    .padding(.bottom, 20)
                
                Image(systemName: "bolt.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .scaleEffect(imageScale)
                    .opacity(imageOpacity)
                    .foregroundStyle(Color.blue)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            imageScale = 1.5
                            imageOpacity = 0.6
                        }
                    }
                
                
            } else {
                Text("Encountered an issue retrieving your analysis, please try again")
                    .font(.system(size: 16, design: .serif))
                    .italic()
                    .bold()
                    .foregroundStyle(Color.red)
            }
        }
        .padding(.bottom, 100)
        .onAppear {
            self.imageScale = 1.0
            self.imageOpacity = 1.0
        }
    }
}

#Preview {
    ShortAnalysisLoadingView()
        .environmentObject(ShortAnalysisController())
}
