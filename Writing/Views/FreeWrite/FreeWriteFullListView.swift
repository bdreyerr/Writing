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
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(freeWriteController.allFreeWrites) { freeWrite in
                            FreeWriteEntryPreviewView(freeWrite: freeWrite)
                                .onTapGesture {
                                    print("it happened, clicked")
                                    freeWriteController.focusFreeWrite(freeWrite: freeWrite)
                                }
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
                            Text("version 1.1 june 2024")
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
            freeWriteController.retrieveAllFreeWrites()
        }
    }
}

#Preview {
    FreeWriteFullListView()
        .environmentObject(FreeWriteController())
}
