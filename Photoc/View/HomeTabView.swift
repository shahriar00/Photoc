//
//  TabView.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/26/25.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView{
            Tab("Home",systemImage: "house.fill"){
                HomeView()
            }
            
            Tab("Profile",systemImage: "person.circle"){
                ProfileView()
            }
            
        }
        .tabViewStyle(.sidebarAdaptable)
        
    }
}

#Preview {
    HomeTabView()
}
