//
//  ProfileAdvertiseWithUsView.swift
//  Writing
//
//  Created by Ben Dreyer on 7/27/24.
//

import SwiftUI

struct ProfileAdvertiseWithUsView: View {
    var body: some View {
        VStack {
            Text("If intersted in advertising for your brand / company / product on the Daily Short, please reach out to the following email for quotes on ad slots:")
                .font(.system(size: 16, design: .serif))
                .italic()
                .padding(5)
            
            
            
            Text("thedailyshortapp@gmail.com")
                .font(.system(size: 16, design: .serif))
                .italic()
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = "thedailyshortapp@gmail.com"
                    }) {
                        Text("Copy")
                        Image(systemName: "doc.on.doc")
                    }
                }
                .padding()
                .font(.title)
                .padding(.bottom, 100)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ProfileAdvertiseWithUsView()
}
