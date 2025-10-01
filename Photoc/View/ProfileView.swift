//
//  ProfileView.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/26/25.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("signin") var signin: Bool = false
    
    @State private var error : String? = nil
    
    var body: some View {
        
        ZStack{
            
            AnimatedGradientBackground()
            
            LoginScreen()
        }
    }
}

#Preview {
    ProfileView()
}
