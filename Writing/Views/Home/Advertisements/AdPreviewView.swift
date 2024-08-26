//
//  AdPreview.swift
//  Writing
//
//  Created by Ben Dreyer on 8/25/24.
//

import SwiftUI

struct AdPreviewView: View {
    @EnvironmentObject var advertisementController: AdvertisementController
    
    
    var body: some View {
        Button(action: {
            advertisementController.isFullAdSheetShowing = true
        }) {
            if let ad = advertisementController.focusedAd {
                VStack {
                    HStack {
                        // Profile Picture
                        
                        if let image = advertisementController.advertiserImage {
                            Image(uiImage: image)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 40, height: 40)
                        } else {
                            Image("not-signed-in-profile")
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(width: 40, height: 40)
                        }
                        
                        
                        
                        VStack {
                            // Advertiser Name
                            Text(ad.advertiserName ?? "Advertiser")
                                .font(.system(size: 12, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                // Subtitle
                                Text(ad.advertiserSubtitle ?? "A publishing company")
                                    .font(.system(size: 10, design: .serif))
                                    .opacity(0.6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    // Content
                    Text(ad.contentPreview ?? "This is an advertisement")
                        .font(.system(size: 13, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        ZStack {
                            HStack {
                                // like image
                                Image(systemName: "hand.thumbsup")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                // like number
                                Text("\((ad.likeCount ?? 0).formatted())")
                                    .font(.system(size: 13, design: .serif))
                            }
                            if advertisementController.isFocusedAdLiked {
                                HStack {
                                    Image(systemName: "hand.thumbsup")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text("\((ad.likeCount ?? 0).formatted())")
                                        .font(.system(size: 13, design: .serif))
                                }
                                .foregroundStyle(Color.orange)
                            }
                        }
                        
                        HStack {
                            // Comment image
                            Image(systemName: "message")
                                .resizable()
                                .frame(width: 15, height: 15)
                            // comment number
                            Text("\((ad.commentCount ?? 0).formatted())")
                                .font(.system(size: 13, design: .serif))
                        }
                        
                        // Report Short
                        Image(systemName: "info.circle")
                            .font(.caption)
                        
                        Text("Sponsored")
                            .font(.system(size: 10, design: .serif))
                            .foregroundStyle(Color.blue)
                            .opacity(0.8)
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 10)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AdPreviewView()
        .environmentObject(AdvertisementController())
}
