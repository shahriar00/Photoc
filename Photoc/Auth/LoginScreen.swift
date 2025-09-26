//
//  LoginScreen.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/26/25.
//

import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseAuth
import UIKit

struct LoginScreen: View {
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            HStack{
                
                LoginButton(onAction: {
                    FirebaseAuth.shared.signInWithGoogle(presenting: getViewController()) { error in
                        print("Google Signin Error: \(String(describing: error))")
                    }
                
                }, image: "google")
                
                LoginButton(onAction: {
                    FirebaseAuth.shared.signInWithApple(presenting: getViewController()) { error in
                        print("Apple Signin Error: \(String(describing: error))")
                    }
                }, image: "apple")
                
            }
            
            Spacer()
        }
    }
}

#Preview {
    LoginScreen()
}
