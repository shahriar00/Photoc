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
                
                VStack(spacing: 24){
                    
                    // Welcome header with icon
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
                        
                        Text("Welcome!")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.9)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    
                    VStack(spacing: 16){
                        
                        if let user = currentUser{
                            
                            if let displayName = user.displayName, !displayName.isEmpty {
                                Text(displayName)
                                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            if let email = user.email {
                                Text(email)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            if let providerData = user.providerData.first {
                                HStack(spacing: 6) {
                                    Image(systemName: getProviderIcon(providerData.providerID))
                                        .font(.system(size: 14))
                                    Text("Signed in with \(getProviderName(providerData.providerID))")
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.top, 4)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        LogOut()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.right.square.fill")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Sign Out")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    .buttonStyle(ScaleButtonStyle())
                }
                
            }else{
                
                VStack(spacing: 28) {
                    
                    // Header
                    VStack(spacing: 8) {
                        Text(isSignUp ? "Create Account" : "Welcome Back")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.9)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Text(isSignUp ? "Sign up to get started" : "Sign in to continue")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    VStack(spacing: 16){
                        
                        // Email Field
                        HStack(spacing: 14) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 24)
                            
                            TextField("Email", text: $email)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        
                        // Password Field
                        HStack(spacing: 14) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 24)
                            
                            SecureField("Password", text: $pass)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                                .textContentType(.password)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                                .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Button{
                        handleEmailAuth()
                    }label: {
                        HStack(spacing: 10) {
                            Text(isSignUp ? "Sign Up" : "Sign In")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.15)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 8)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.5),
                                            Color.white.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    .buttonStyle(ScaleButtonStyle())
                    
                    Button{
                        isSignUp.toggle()
                    }label: {
                        Text(isSignUp ? "Already have an account? **Sign In**" : "Don't have an account? **Sign Up**")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .buttonStyle(ScaleButtonStyles(scale: 0.98))
                    
                    HStack(spacing: 16) {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0),
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 1)
                        
                        Text("OR")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0),
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0)
                                    ],
                                    startPoint: .trailing,
                                    endPoint: .leading
                                )
                            )
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                    
                    HStack(spacing: 20){
                        
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
    
    private func getProviderIcon(_ providerID: String) -> String {
        switch providerID {
        case "google.com":
            return "g.circle.fill"
        case "apple.com":
            return "apple.logo"
        case "password":
            return "envelope.circle.fill"
        default:
            return "questionmark.circle.fill"
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

