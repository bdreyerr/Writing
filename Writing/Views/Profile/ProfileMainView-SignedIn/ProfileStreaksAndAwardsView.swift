//
//  ProfileStreaksAndAwardsView.swift
//  Writing
//
//  Created by Ben Dreyer on 7/8/24.
//

import FirebaseFirestore
import SwiftUI

struct ProfileStreaksAndAwardsView: View {
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        VStack {
            // Current Streak
            VStack {
                Text("Current Streak")
                    .font(.system(size: 18, design: .serif))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image("fire")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.orange)
                    
                    
                    VStack {
                        if let user = userController.user {
                            if let currentStreak = user.currentStreak {
                                
                                // Make sure the current streak is active
                                // The last Short Written date should be yesterday
                                
                                if let lastShortWrittenDate = user.lastShortWrittenDate {
                                    let dateValueOfLastShort = lastShortWrittenDate.dateValue()
                                    
                                    if self.isYesterdayOrToday(date: dateValueOfLastShort) {
                                        Text("\(currentStreak)")
                                            .font(.system(size: 16, design: .serif))
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Text("0")
                                            .font(.system(size: 16, design: .serif))
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                
                                Text("Day Writing Streak")
                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 10)
            
            // Personal Best
            VStack {
                Text("Personal Best")
                    .font(.system(size: 18, design: .serif))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image("fire")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.orange)
                    
                    
                    VStack {
                        if let user = userController.user {
                            if let bestStreak = user.bestStreak {
                                Text("\(bestStreak)")
                                    .font(.system(size: 16, design: .serif))
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        Text("Days")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 10)
            
            
            VStack {
                Text("Titles")
                    .font(.system(size: 18, design: .serif))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("Current Title:")
                        .font(.system(size: 14, design: .serif))
                        .bold()
                        
                    if let user = userController.user {
                        Text(profileController.convertTitleIntToString(int: user.title ?? 0))
                            .font(.system(size: 14, design: .serif))
                    } else {
                        Text("Pupil")
                            .font(.system(size: 14, design: .serif))
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
                
                HStack {
                    Text("Next:")
                        .font(.system(size: 14, design: .serif))
                        .bold()
                    
                    if let user = userController.user {
                        Text(profileController.convertTitleIntToString(int: (user.title ?? 0) + 1))
                            .font(.system(size: 14, design: .serif))
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 1)
                
                HStack {
                    Text("Criteria:")
                        .font(.system(size: 14, design: .serif))
                        .bold()
                        
                    
                    if let user = userController.user {
                        Text(profileController.getNextTitleCriteria(curLevel: user.title ?? 0, numShorts: user.shortsCount ?? 0))
                            .font(.system(size: 14, design: .serif))
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 10)
            
            HStack {
                // Contribution Graph
                VStack {
                    Text("Contributions")
                        .bold()
                        .font(.system(size: 18, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ZStack {
                        VStack(alignment: .leading) {
                            ForEach(0..<profileController.contributions.count, id: \.self) { row in
                                HStack(spacing: 2.5) {
                                    ForEach(0..<profileController.contributions[row].count, id: \.self) { column in
                                        RoundedRectangle(cornerRadius: 1.5)
                                            .foregroundStyle(profileController.contributions[row][column] == 1 ? Color.green : Color.gray)
                                            .frame(width: 15, height: 15)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.bottom, 10)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    func isYesterdayOrToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDateInToday(date) || calendar.isDateInYesterday(date)
    }
}

#Preview {
    ProfileStreaksAndAwardsView()
        .environmentObject(ProfileController())
        .environmentObject(UserController())
}
