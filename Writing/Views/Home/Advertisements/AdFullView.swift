//
//  AdFullView.swift
//  Writing
//
//  Created by Ben Dreyer on 8/25/24.
//

import SwiftUI

struct AdFullView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var advertisementController: AdvertisementController
    
    var body: some View {
        ZStack {
            if let ad = advertisementController.focusedAd {
                VStack {

                    
                    ScrollView(showsIndicators: false) {
                        HStack {
                            // Image
                            if let image = advertisementController.advertiserImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .frame(width: 60, height: 60)
                            } else {
                                Image("not-signed-in-profile")
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .frame(width: 60, height: 60)
                            }
                            
                            VStack {
                                // Advertiser Name
                                Text(ad.advertiserName ?? "Advertiser")
                                    .font(.system(size: 14, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    // Subtitle
                                    Text(ad.advertiserSubtitle ?? "A publishing company")
                                        .font(.system(size: 12, design: .serif))
                                        .opacity(0.6)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        
                        
                        // Full Content
                        Text(ad.contentFull ?? "This is an advertisement")
                            .font(.system(size: 15, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            // Like Button
                            Button(action: {
                                advertisementController.isFocusedAdLiked.toggle()
                            }) {
                                ZStack {
                                    // Unliked like count (no color)
                                    HStack {
                                        // Comment image
                                        Image(systemName: "hand.thumbsup")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        // comment number
                                        Text("\((ad.likeCount ?? 0).formatted())")
                                            .font(.system(size: 13, design: .serif))
                                    }
                                    if advertisementController.isFocusedAdLiked {
                                        HStack {
                                            // Comment image
                                            Image(systemName: "hand.thumbsup")
                                                .resizable()
                                                .frame(width: 15, height: 15)
                                            // comment number
                                            Text("\((ad.likeCount ?? 0).formatted())")
                                                .font(.system(size: 13, design: .serif))
                                        }
                                        .foregroundStyle(Color.orange)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            HStack {
                                // Comment image
                                Image(systemName: "message")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                // comment number
                                Text("\((ad.commentCount ?? 0).formatted())")
                                    .font(.system(size: 13, design: .serif))
                            }
                            
                            // Report Ad
                            
                            
                            // Sponsored text
                            Text("Sponsored")
                                .font(.system(size: 10, design: .serif))
                                .foregroundStyle(Color.blue)
                                .opacity(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        // Redirect Button
                        Link("Learn More", destination: URL(string: ad.redirectUrl ?? "")!)
                            .foregroundColor(.blue)
                    }
                    
                    // Daily Short Logo?
                    if (colorScheme == .light) {
                        Image("LogoTransparentWhiteBackground")
                            .resizable()
                            .frame(width: 80, height: 80)
                    } else if (colorScheme == .dark) {
                        Image("LogoBlackBackground")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    AdFullView()
        .environmentObject(AdvertisementController())
}
