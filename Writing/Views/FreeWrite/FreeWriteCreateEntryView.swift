//
//  FreeWriteCreateEntryView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/16/24.
//

import SwiftUI

struct FreeWriteCreateEntryView: View {
    @AppStorage("isTabBarShowing") private var isTabBarShowing = true
    
    @State private var title: String = ""
    @State private var icon: String = "sun.max"
    @State private var entryText: String = ""
    
    var body: some View {
        
        
        ZStack {
            VStack {
                
                HStack {
                    TextField("A poem about ..", text: $title)
                        .font(.system(size: 20, design: .serif))
                    
                    HStack {
                        Image(systemName: "sun.max")
                        
                        Button(action: {
                            
                        }) {
                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 15, height: 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 10)
                ScrollView(showsIndicators: false) {
                    TextField("Once upon a time...",text: $entryText, axis: .vertical)
                    //                    .modifier(KeyboardAdaptive())
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
                    HStack {
                        // Character Count
                        Text("\(self.entryText.count) / 3000 Characters")
                            .font(.system(size: 12, design: .serif))
                        
                        Image(systemName: "arrowshape.right.circle")
                            .font(.callout)
                            .foregroundStyle(Color.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
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
    FreeWriteCreateEntryView()
}
