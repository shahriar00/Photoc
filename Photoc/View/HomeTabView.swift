//
//  TabView.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/26/25.
//

import SwiftUI

struct TabView: View {
    var body: some View {
        TabView{
            Tab("Home",systemImage: "person"){
                HomeView()
            }
        }
        
    }
}

#Preview {
    TabView()
}
