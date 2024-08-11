//
//  ProfileChangePhotoView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/27/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ProfileChangePhotoView: View {
    @EnvironmentObject var profileController: ProfileController
    @EnvironmentObject var userController: UserController
    
    @State private var data: Data?
    @State private var selectedItem: [PhotosPickerItem] = []
    
    var body: some View {
        Form {
            Section {
                PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                    if let data = data, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(maxWidth: 140, maxHeight: 140, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Label("Select a picture", systemImage: "photo.on.rectangle.angled")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxHeight: 200)
            .onChange(of: selectedItem, {
                Task {
                    DispatchQueue.main.async {
                        guard let item = selectedItem.first else {
                            return
                        }
                        
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.data = data
                                }
                            case .failure(let failure):
                                print("Error: \(failure.localizedDescription)")
                            }
                        }
                    }
                }
            })
            Section {
                Button("Confirm") {
                    if let rateLimit = userController.processFirestoreWrite() {
                        print(rateLimit)
                    } else {
                        // Function to post data to Firebase Storage
                        // we can assume data is not nill because the button is disabled if it is.
                        userController.uploadProfilePicture(data: self.data!)
                        profileController.isChangePhotoSheetShowing = false
                    }
                }.disabled(self.data == nil)
            }
        }
    }
}

#Preview {
    ProfileChangePhotoView()
}
