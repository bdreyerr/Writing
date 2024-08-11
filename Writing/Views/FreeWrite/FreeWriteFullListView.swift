//
//  FreeWriteFullListView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/30/24.
//

import SwiftUI

struct FreeWriteFullListView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var freeWriteController: FreeWriteController
    var body: some View {
        ZStack {
            VStack {
                // Logo / Slogan / Free Write
                HStack {
                    // Small Logo
                    if (colorScheme == .light) {
                        Image("LogoTransparentWhiteBackground")
                            .resizable()
                            .frame(width: 30, height: 30)
                    } else if (colorScheme == .dark) {
                        Image("LogoBlackBackground")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text("| The Daily Short")
                        .font(.system(size: 16, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    Text("Free Write")
                        .font(.system(size: 16, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .bold()
                }
                .padding(.top, 15)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                
                // Sort By
                HStack {
                    Menu {
                        Button(action: {
                            freeWriteController.selectedSortingMethod = 0
                            freeWriteController.switchSortingMethod()
                        }) {
                            HStack {
                                Text("Recent")
                                    .font(.system(size: 13, design: .serif))
                                
//                                Image(systemName: "clock")
//                                    .font(.subheadline)
                            }
                            
                        }
                        Button(action: {
                            freeWriteController.selectedSortingMethod = 1
                            freeWriteController.switchSortingMethod()
                        }) {
                            HStack {
                                Text("Oldest")
                                    .font(.system(size: 13, design: .serif))
                                
//                                Image(systemName: "crown")
//                                    .font(.subheadline)
                            }
                        }
                    } label: {
                        HStack {
                            if freeWriteController.selectedSortingMethod == 0 {
                                Text("Recent")
                                    .font(.system(size: 13, design: .serif))
                            } else if freeWriteController.selectedSortingMethod == 1 {
                                Text("Oldest")
                                    .font(.system(size: 13, design: .serif))
                            }
                            Image(systemName: "chevron.down")
                                .font(.subheadline)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        if freeWriteController.selectedSortingMethod == 0 {
                            ForEach(freeWriteController.freeWrites) { freeWrite in
                                FreeWriteEntryPreviewView(freeWrite: freeWrite)
                                    .onTapGesture {
                                        freeWriteController.focusFreeWrite(freeWrite: freeWrite)
                                    }
                            }
                        } else if freeWriteController.selectedSortingMethod == 1 {
                            ForEach(freeWriteController.freeWritesOldest) { freeWrite in
                                FreeWriteEntryPreviewView(freeWrite: freeWrite)
                                    .onTapGesture {
                                        freeWriteController.focusFreeWrite(freeWrite: freeWrite)
                                    }
                            }
                        }
                        
                        // Older button (allows user to load next batch of free writes)
                        if !freeWriteController.areNoShortsLeftToLoad {
                            Button(action: {
                                freeWriteController.retrieveNextFreeWrites()
                            }) {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 110, height: 35)
                                    .overlay {
                                        HStack {
                                            Text("More")
                                                .font(.system(size: 14, design: .serif))
                                                .bold()
                                            
                                            Image(systemName: "arrow.down")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                        }
                                    }
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
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
                            Text("version 1.1")
                                .font(.system(size: 11, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .bottom)
                                .opacity(0.8)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            freeWriteController.retrieveNextFreeWrites()
        }
    }
}

#Preview {
    FreeWriteFullListView()
        .environmentObject(FreeWriteController())
}
