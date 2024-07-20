//
//  ShortAnalysisMainView.swift
//  Writing
//
//  Created by Ben Dreyer on 7/13/24.
//

import SwiftUI

struct ShortAnalysisMainView: View {
    
    @StateObject var shortAnalysisController = ShortAnalysisController()
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    
                    if shortAnalysisController.isLoadingAnalysis {
                        ShortAnalysisLoadingView()
                    } else {
                        Image(systemName: "bolt.circle")
                            .font(.title)
                            .foregroundStyle(Color.blue)
                        
                        Text("What You Wrote")
                            .font(.system(size: 16, design: .serif))
                            .padding(.top, 15)
                            .padding(.bottom, 15)
                            .bold()
                        
                        
                        if let short = profileController.focusedShort {
                            Text(short.shortRawText ?? "")
                                .font(.system(size: 13, design: .serif))
                                .padding(.bottom, 10)
                        }
                        
                        if let analysis = shortAnalysisController.focusedShortAnalysis {
                            // the analysis was retrieved
                            HStack {
                                Text("What We Think")
                                    .font(.system(size: 16, design: .serif))
                                    .padding(.top, 15)
                                    .padding(.bottom, 15)
                                    .bold()
                                
                                
                                Button {
                                    shortAnalysisController.isAnalysisHelpPopoverShowing.toggle()
                                } label: {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .frame(maxWidth: 14, maxHeight: 14)
                                        .popover(isPresented: $shortAnalysisController.isAnalysisHelpPopoverShowing,
                                                 attachmentAnchor: .point(.top),
                                                 arrowEdge: .top,
                                                 content: {
                                            VStack {
                                                Text("We use external ai (openai) to analyze")
                                                Text("your writing. This analysis is not an")
                                                Text("official indication of how well you")
                                                Text("write, but a simple prediction based")
                                                Text("on the words the ai models have been trained ")
                                                Text("on. Please do not use our analysis as an")
                                                Text("official metric to judge your writing.")
                                            }
                                            
                                            .multilineTextAlignment(.center)
                                            .lineLimit(0)
                                            //                                .foregroundStyle(.black)
                                            .font(.system(size: 10, weight: .medium, design: .rounded))
                                            .padding()
                                            .presentationCompactAdaptation(.none)
                                        })
                                }
                            }
                            
                            
                            // Scoring
                            HStack {
                                // Prose
                                VStack {
                                    Text(String(format: "%.1f", analysis.proseScore ?? 0.0))
                                        .font(.system(size: 24, design: .serif))
                                        .bold()
                                        .foregroundStyle(shortAnalysisController.determineScoreColor(score: analysis.proseScore ?? 0.0))
                                    
                                    Text("Prose")
                                        .font(.system(size: 14, design: .serif))
                                }
                                // Imagery
                                VStack {
                                    Text(String(format: "%.1f", analysis.imageryScore ?? 0.0))
                                        .font(.system(size: 24, design: .serif))
                                        .bold()
                                        .foregroundStyle(shortAnalysisController.determineScoreColor(score: analysis.imageryScore ?? 0.0))
                                    
                                    Text("Imagery")
                                        .font(.system(size: 14, design: .serif))
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                
                                
                                // Flow
                                VStack {
                                    Text(String(format: "%.1f", analysis.flowScore ?? 0.0))
                                        .font(.system(size: 24, design: .serif))
                                        .bold()
                                        .foregroundStyle(shortAnalysisController.determineScoreColor(score: analysis.flowScore ?? 0.0))
                                    
                                    Text("Flow")
                                        .font(.system(size: 14, design: .serif))
                                }
                            }
                            .padding(.bottom, 2)
                            
                            // Text Analysis
                            Text(analysis.content ?? "")
                                .font(.system(size: 15, design: .serif))
                                .padding(.bottom, 10)
                            
                            Text(String(format: "%.1f", analysis.score ?? 0.0))
                                .font(.system(size: 28, design: .serif))
                                .bold()
                                .foregroundStyle(shortAnalysisController.determineScoreColor(score: analysis.score ?? 0.0))
                            
                            
                            Text("Overall")
                                .font(.system(size: 18, design: .serif))
                        } else {
                            // else there's no analysis yet
                            Button(action: {
                                shortAnalysisController.isConfirmCreateAnalysisAlertShowing = true
                            }) {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 200, height: 40)
                                    .overlay {
                                        HStack {
                                            Text("Generate Analysis")
                                                .font(.system(size: 13, design: .serif))
                                                .bold()
                                            Image(systemName: "bolt")
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundStyle(Color.blue)
                            .alert("Are you sure?", isPresented: $shortAnalysisController.isConfirmCreateAnalysisAlertShowing) {
                                
                                Button("Confirm") {
                                    Task {
                                        if let user = userController.user {
                                            if let short = profileController.focusedShort {
                                                shortAnalysisController.createAnalysis(user: user, short: short)
                                                
                                                // Update the user vars (avg writing score got updated)
//                                                userController.retrieveUserFromFirestore(userId: user.id!)
                                            }
                                        }
                                    }
                                }
                                
                                Button("Cancel", role: .cancel) { }
                            }
                            
                        }
                        
                        
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
        .onAppear {
            if let _ = userController.user {
                if let short = profileController.focusedShort {
                    shortAnalysisController.retrieveAnalysis(shortId: short.id!)
                }
            }
        }
        .environmentObject(shortAnalysisController)
    
    }
}

#Preview {
    ShortAnalysisMainView()
        .environmentObject(ShortAnalysisController())
        .environmentObject(ProfileController())
        .environmentObject(UserController())
}
