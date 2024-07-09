//
//  FreeWriteEditEntryView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/30/24.
//

import SwiftUI

struct FreeWriteEditEntryView: View {
    @AppStorage("isTabBarShowing") private var isTabBarShowing = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @EnvironmentObject var freeWriteController: FreeWriteController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("A poem about...", text: $freeWriteController.titleText)
                        .font(.system(size: 20, design: .serif))
                    
                    HStack {
//                        Image(systemName: freeWriteController.iconName)
                        
                        Picker("", selection: $freeWriteController.iconName) {
                            ForEach(freeWriteController.iconOptions, id: \.self) { image in
                                Image(systemName: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)  // Adjust size as needed
                                    .foregroundColor(.black)
                                    .tag(freeWriteController.iconOptions.firstIndex(of: image)!)
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .accentColor(self.isDarkMode ? Color.white : Color.black)
                        
//                        Button(action: {
//
//                        }) {
//                            Image(systemName: "arrowtriangle.down.fill")
//                                .resizable()
//                                .frame(width: 15, height: 10)
//                        }
//                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false) {
                    TextField("Once upon a time...",text: $freeWriteController.contentText, axis: .vertical)
                        .font(.system(size: 16, design: .serif))
                    // Styling
                        .padding(.vertical, 8)
                        .background(
                            VStack {
                                Spacer()
                                Color(UIColor.systemGray4)
                                    .frame(height: 2)
                            }
                        )
                        .onChange(of: freeWriteController.contentText) {
                            freeWriteController.updateWordCount()
                        }
                    
                    HStack {
                        // Character Count
                        Text("\(freeWriteController.wordCount) Words")
                            .font(.system(size: 12, design: .serif))
                        
                        
                        Button(action: {
                            // Rate Limiting check
                            if let rateLimit = userController.processFirestoreWrite() {
                                print(rateLimit)
                            } else {
                                if let user = userController.user {
                                    Task {
                                        freeWriteController.editFreeWrite(freeWriteCount: user.freeWriteCount!, freeWriteOldAverageWordCount: user.freeWriteAverageWordCount!)
                                        
                                        
                                        // re-pull the freewrites for the user
                                        freeWriteController.retrieveFreeWrites()
                                        
                                        // re-pull the user in user controller
                                        userController.retrieveUserFromFirestore(userId: user.id!)
                                    }
                                }
                            }
                        }) {
                            Image(systemName: "arrowshape.right.circle")
                                .font(.callout)
                                .foregroundStyle(Color.green)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(freeWriteController.titleText.isEmpty || freeWriteController.contentText.isEmpty)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .onAppear {
                if let freeWrite = freeWriteController.focusedFreeWrite {
                    freeWriteController.titleText = freeWrite.title!
                    freeWriteController.iconName = freeWrite.symbol!
                    freeWriteController.contentText = freeWrite.content!
                    freeWriteController.wordCount = freeWrite.wordCount!
                }
            }
            .onAppear {
                self.isTabBarShowing = false
            }
            .onDisappear {
                self.isTabBarShowing = true
            }
        }
    }
}

#Preview {
    FreeWriteEditEntryView()
}
