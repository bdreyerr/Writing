//
//  FreeWriteMainView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/16/24.
//

import SwiftUI

struct FreeWriteMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var freeWriteController = FreeWriteController()
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        NavigationView {
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
                            // Writing Stats
                            HStack {
                                VStack {
                                    Text("\(userController.user?.freeWriteCount ?? 0)")
                                        .font(.system(size: 20, design: .serif))
                                    
                                    Text("Entries")
                                        .font(.system(size: 12, design: .serif))
                                }
                                .padding()
                                
                                VStack {
                                    Text("\(userController.user?.freeWriteAverageWordCount ?? 0)")
                                        .font(.system(size: 20, design: .serif))
                                    
                                    Text("Avg Word Count")
                                        .font(.system(size: 12, design: .serif))
                                }
                                .padding()
                            }
                            
                            HStack {
                                Text("Latest Entries")
                                    .font(.system(size: 16, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                
                                NavigationLink(destination: FreeWriteFullListView()) {
                                    Text("View All")
                                        .font(.system(size: 12, design: .serif))
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                            .padding(.bottom, 10)
                            
                            
                            ForEach(freeWriteController.freeWrites) { freeWrite in
                                FreeWriteEntryPreviewView(freeWrite: freeWrite)
                                    .onTapGesture {
                                        print("it happened, clicked")
                                        freeWriteController.focusFreeWrite(freeWrite: freeWrite)
                                    }
                            }
                            
                            NavigationLink(destination: FreeWriteCreateEntryView()) {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(lineWidth: 1)
                                    .frame(width: 160, height: 40)
                                    .overlay {
                                        HStack {
                                            // TODO(bendreyer): have a couple different openers here (start your creation, dive right in, etc..) and pick one at random
                                            Text("Create Entry")
                                                .font(.system(size: 14, design: .serif))
                                                .bold()
                                            
                                            Image(systemName: "pencil.and.scribble")
                                            
                                        }
                                    }
                                    .padding(.bottom, 10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
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
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    }
                }
                .sheet(isPresented: $freeWriteController.isSingleFreeWriteSheetShowing) {
                    FreeWriteSingleEntryView()
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.automatic)
                }
            }
            .padding(.bottom, 25)
        }
        .environmentObject(freeWriteController)
    }
}

#Preview {
    FreeWriteMainView()
        .environmentObject(FreeWriteController())
        .environmentObject(UserController())
}
