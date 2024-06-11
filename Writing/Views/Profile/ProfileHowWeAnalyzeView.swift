//
//  ProfileHowWeAnalyzeView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/9/24.
//

import SwiftUI

struct ProfileHowWeAnalyzeView: View {
    var body: some View {
        Text("We use external ai (openai) to analyze your writing. This analysis is not an official indication of how well you write, but a simple prediction based on the words the ai models have been trained on. Please do not use our analysis as an official metric to judge your writing.")
            .font(.system(size: 16, design: .serif))
            .italic()
            .padding(20)
            .padding(.bottom, 100)
    }
}

#Preview {
    ProfileHowWeAnalyzeView()
}
