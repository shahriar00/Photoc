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
        if signin {
            Text("Profile View")
            
            Button{
                Task{
                    do{
                       try await FirebaseAuth.shared.signOut()
                    }catch let err {
                        error = err.localizedDescription
                    }
                }
                
            }label: {
                Text("Sign Out")
                    .foregroundColor(.red)
                    .padding(8)
            }
            .buttonStyle(.glassProminent)
        }else{
            LoginScreen()
        }
    }
}

#Preview {
    ProfileView()
}
