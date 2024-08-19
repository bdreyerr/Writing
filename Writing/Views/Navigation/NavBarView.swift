//
//  NavBarView.swift
//  Writing
//
//  Created by Ben Dreyer on 6/4/24.
//

import SwiftUI

struct NavBarView: View {
    //    @AppStorage("isSignedIn") private var isSignedIn = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isTabBarShowing") private var isTabBarShowing = true
    
    @State var selectedTab = 0
    
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeMainView()
                    .tag(0)
                
                FreeWriteContentView()
                    .tag(1)
                
                ProfileContentView()
                    .tag(2)
            }
            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            // Border
//            .frame(maxWidth: 100)
            .frame(height: 70)
            .background(colorScheme == .light ? .white.opacity(0.6) : .black.opacity(0.6))
            .cornerRadius(35)
            .overlay(
                RoundedRectangle(cornerRadius: 35)
                    .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 1) // 1 px border
            )
            .padding(.horizontal, 80)
            // tab bar visibility
            .opacity(self.isTabBarShowing ? 1.0 : 0.0)
            
            
        }
        //        TabView {
        //            Group {
        //                HomeMainView()
        //                    .tabItem {
        //                        Label("Home", systemImage: "house")
        //                    }
        //
        //                ProfileContentView()
        //                    .tabItem { Label("Profile", systemImage: "person") }
        //
        //            }
        //            .toolbarBackground(.visible, for: .tabBar)
        //        }
    }
}

#Preview {
    NavBarView()
        .environmentObject(AuthController())
        .environmentObject(ProfileController())
        .environmentObject(UserController())
        .environmentObject(HomeController())
        .environmentObject(CreateShortController())
}

enum TabbedItems : Int, CaseIterable {
    case home = 0
    
    case freeWrite
    case profile
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .freeWrite:
            return "Free Write"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .freeWrite:
            return "books.vertical"
        case .profile:
            return "person"
        }
    }
}


extension NavBarView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(systemName: imageName)
                .resizable()
                .renderingMode(.template)
//                .foregroundColor(isActive ? .black : .gray)
                .foregroundColor(colorScheme == .light ? isActive ? .white : .gray : isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            if isActive{
//                Text(title)
//                    .font(.system(size: 14))
////                    .foregroundColor(isActive ? .black : .gray)
//                    .foregroundColor(colorScheme == .light ? .white : .black)
            }
            Spacer()
        }
        .frame(maxWidth: isActive ? 100 : 60, maxHeight: 60)
//        .background(isActive ? .white.opacity(0.4) : .clear)
        .background(colorScheme == .light ? isActive ? .black.opacity(0.9) : .clear : isActive ? .white.opacity(0.9) : .clear)
        .cornerRadius(30)
    }
}
