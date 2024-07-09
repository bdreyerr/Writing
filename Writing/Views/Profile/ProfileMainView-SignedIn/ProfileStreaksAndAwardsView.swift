//
//  ProfileStreaksAndAwardsView.swift
//  Writing
//
//  Created by Ben Dreyer on 7/8/24.
//

import SwiftUI

struct ProfileStreaksAndAwardsView: View {
    @EnvironmentObject var profileController: ProfileController
    
    var body: some View {
        VStack {
            // Streaks
            HStack {
                // Count
                HStack {
                    Image("fire")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.orange)
                    
                    
                    VStack {
                        Text("19")
                            .font(.system(size: 16, design: .serif))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Day Streak")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Contribution Graph
                VStack {
                    Text("Contributions")
                        .bold()
                        .font(.system(size: 12, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ZStack{
                        VStack(alignment: .leading) {
                            ForEach(0..<profileController.contributions.count, id: \.self) { row in
                                HStack(spacing: 2.5) {
                                    ForEach(0..<profileController.contributions[row].count, id: \.self) { column in
                                        RoundedRectangle(cornerRadius: 1.5)
                                            .foregroundStyle(profileController.contributions[row][column] == 1 ? Color.green : Color.gray)
                                            .frame(width: 10, height: 10)
                                    }
                                }
                            }
                        }
                        //                                            .padding(10)
                        .overlay {
                            //                                                RoundedRectangle(cornerRadius: 10)
                            //                                                    .stroke(Color.black, lineWidth: 1)
                        }
                    }
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ProfileStreaksAndAwardsView()
        .environmentObject(ProfileController())
}
