//
//  FreeWriteEntryPreviewView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/29/24.
//

import FirebaseFirestore
import SwiftUI

struct FreeWriteEntryPreviewView: View {
    @EnvironmentObject var freeWriteController: FreeWriteController
    
    var freeWrite: FreeWrite
    
    let calendar = Calendar.current
    
    var body: some View {
        VStack {
            Button(action: {
                freeWriteController.focusFreeWrite(freeWrite: self.freeWrite)
                freeWriteController.isSingleFreeWriteSheetShowing = true
            }) {
                VStack {
                    HStack {
                        VStack {
                            Text("\(calendar.component(.day, from: freeWrite.rawTimestamp!.dateValue()))")
                                .font(.system(size: 14, design: .serif))
                            
                            Text(self.getMonthString(from: freeWrite.rawTimestamp!.dateValue()))
                                .font(.system(size: 12, design: .serif))
                        }
                        
                        
                        Text("|")
                            .font(.system(size: 25, design: .serif))
                        
                        VStack {
                            Text(freeWrite.title!)
                                .font(.system(size: 16, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Text("Last Updated \(freeWrite.rawTimestamp!.dateValue().formatted(date: .omitted, time: .shortened))")
                                    .font(.system(size: 12, design: .serif))
                                
                                Text("●")
                                    .font(.system(size: 12, design: .serif))
                                
                                Text("\(freeWrite.wordCount!) words")
                                    .font(.system(size: 12, design: .serif))
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Image(systemName: freeWrite.symbol!)
                            .font(.headline)
                        
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    func getMonthString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM" // "MMMM" for full month name, "MMM" for abbreviated month name
        return dateFormatter.string(from: date)
    }
}

#Preview {
    FreeWriteEntryPreviewView(freeWrite: FreeWrite(rawTimestamp: Timestamp(), title: "Title", symbol: "sun.max", content: "The content of it all", wordCount: 5))
        .environmentObject(FreeWriteController())
}
