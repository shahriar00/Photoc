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


struct LoginScreen: View {
    
    @State var email: String = ""
    @State var pass: String = ""
    @State private var isSignUp: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSignedIn: Bool = UserDefaults.standard.bool(forKey: "signin")
    @State private var currentUser: User? = Auth.auth().currentUser
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            if isSignedIn {
                
                VStack{
                    
                    Text("Welcome!")
                       .font(.largeTitle)
                      .fontWeight(.bold)
                    
                    VStack(spacing: 9){
                        
                        if let user = currentUser{
                            
                            if let displayName = user.displayName, !displayName.isEmpty {
                                Text(displayName)
                                    .font(.title2)
                                    .fontWeight(.medium)
                            }
                            
                            if let email = user.email {
                                Text(email)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            
                            if let providerData = user.providerData.first {
                                 Text("Signed in with \(getProviderName(providerData.providerID))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button(action: {
                         LogOut()
                     }) {
                         Text("Logout")
                             .foregroundColor(.gray)
                             .frame(maxWidth: .infinity)
                             .padding()
                           
                             .cornerRadius(10)
                     }
                     .glassEffect(.clear)
                     .padding(.horizontal, 20)
                
                }

                
            }else{
                
                Text(isSignUp ? "Create Account" : "Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack{
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .padding()
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $pass)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                .padding(.horizontal)
                
                Button{
                    handleEmailAuth()
                }label: {
                    Text(isSignUp ? "Sign Up" : "Sign In")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                       
                        .cornerRadius(10)
                }
                .glassEffect(.clear)
                .padding(.horizontal,20)
              
               
                
                Button{
                    isSignUp.toggle()
                }label: {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                }
                
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                    
                    Text("OR")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)
                
                HStack{
                    
                    LoginButton(onAction: {
                        FirebaseAuth.shared.signInWithGoogle(presenting: getViewController()) { error in
                            print("Google Signin Error: \(String(describing: error))")
                            
                            if error == nil{
                                isSignedIn = true
                                currentUser = Auth.auth().currentUser
                            }
                        }
                        
                    }, image: "google")
                    
                    LoginButton(onAction: {
                        FirebaseAuth.shared.signInWithApple(presenting: getViewController()) { error in
                            print("Apple Signin Error: \(String(describing: error))")
                            
                            if error == nil{
                                isSignedIn = true
                                currentUser = Auth.auth().currentUser
                            }
                        }
                    }, image: "apple")
                    
                }
                
            }
            
            Spacer()
        }
        .alert("Authentication Error", isPresented: $showError) {
              Button("OK") { }
          } message: {
              Text(errorMessage)
          }
    }
    
    private func getProviderName(_ providerID: String) -> String {
        switch providerID {
        case "google.com":
            return "Google"
        case "apple.com":
            return "Apple"
        case "password":
            return "Email"
        default:
            return "Unknown"
        }
    }
    
    func LogOut(){
        Task{
            do{
                try await FirebaseAuth.shared.signOut()
                currentUser = nil
                email = ""
                pass = ""
                isSignedIn = false
            }catch {
                print("Logout error: \(error.localizedDescription)")
                showErrorMessage("Failed to logout: \(error.localizedDescription)")
            }
        }
    }
    
    func handleEmailAuth(){
        guard !email.isEmpty || !pass.isEmpty else{
            showErrorMessage("Please fill in both email and password")
            return
        }
        
        guard isValidEmail(email) else{
            showErrorMessage("Please enter a valid email address")
            return
        }
        guard pass.count >= 6 else{
            showErrorMessage("Password must be at least 6 characters long")
            return
        }
        
        if isSignUp {
            FirebaseAuth.shared.signUpWithEmail(email: email, password: pass) { error in
                handleAuthError(error: error, method: "Email Sign Up")
                if error == nil {
                    isSignedIn = true
                    currentUser = Auth.auth().currentUser
                }
            }
        }else{
            FirebaseAuth.shared.signInWithEmail(email: email, password: pass) { error in
                    handleAuthError(error: error, method: "Email Sign In")
                    if error == nil {
                        isSignedIn = true
                        currentUser = Auth.auth().currentUser
                 }
              }
        }
    }
    
    private func handleAuthError(error: Error?, method: String) {
        if let error = error {
            print("\(method) Error: \(error.localizedDescription)")
            showErrorMessage(error.localizedDescription)
        } else {
            // Also update social login success
            if method.contains("Google") || method.contains("Apple") {
                isSignedIn = true
                currentUser = Auth.auth().currentUser
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

#Preview {
    LoginScreen()
}
