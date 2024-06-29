//
//  FreeWriteSingleEntryView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/16/24.
//

import SwiftUI

struct FreeWriteSingleEntryView: View {
    @EnvironmentObject var freeWriteController: FreeWriteController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        if let freeWrite = freeWriteController.focusedFreeWrite {
            VStack {
                HStack {
                    // Profile Picture
                    if let image = userController.usersProfilePicture {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    } else {
                        Image("not-signed-in-profile")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                    }
                    
                    
                    // Name and time posted
                    VStack {
                        // Title
                        Text((userController.user?.firstName ?? "Guest ") + " " + (userController.user?.lastName ?? "Writer"))
                            .font(.system(size: 12, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Date
                        Text("\(freeWrite.rawTimestamp!.dateValue().formatted(date: .abbreviated, time: .shortened))")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Image(systemName: freeWrite.symbol!)
                        .font(.headline)
                }
                .padding(.bottom, 10)
                
                // Title
                Text(freeWrite.title!)
                    .font(.system(size: 20, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                
                // Content
                ScrollView(showsIndicators: false) {
                    
                    Text(freeWrite.content!)
                        .font(.system(size: 16, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
        } else {
            Text("we had trouble loading your entry, sawwwyy :((")
                .italic()
        }
        
    }
}

#Preview {
    FreeWriteSingleEntryView()
        .environmentObject(FreeWriteController())
}
