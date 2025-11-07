//
//  FirebaseAuth.swift
//  Photoc
//
//  Created by Shahriar Islam Sazid on 9/26/25.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import Firebase
import AuthenticationServices
import CryptoKit

struct FirebaseAuth {
    
    static var shared = FirebaseAuth()
    
    private init(){}
    
    func signInWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void ){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) {  result, error in
          guard error == nil else {
            // ...
              completion(error)
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                print("Google Sign in successful")
                UserDefaults.standard.set(true, forKey: "signin")
                
                // ✅ Trigger instant UI update
                    DispatchQueue.main.async {
                        completion(nil)
                    }
            }
        }
    }
    
    private var currentNonce: String?
    
    func signInWithApple(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
 
        let nonce = randomNonceString()
        
        // Create Apple ID authorization request
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        let coordinator = AppleSignInCoordinator(completion: completion, nonce: nonce)
        
        authorizationController.delegate = coordinator
        authorizationController.presentationContextProvider = coordinator

        objc_setAssociatedObject(presenting, "appleSignInCoordinator", coordinator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        authorizationController.performRequests()
    }
    
    func signInWithEmail(email: String , password: String , completion: @escaping(Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
            guard  error == nil else {
                completion(error)
                return
            }
            
            print("Email Sign in Successfull")
            UserDefaults.standard.set(true, forKey: "signin")
            completion(nil)
            
        }
    }
    
    func signUpWithEmail(email: String , password: String , completion: @escaping(Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            guard  error == nil else {
                completion(error)
                return
            }
            
            print("Email Sign Up in Successfull")
            UserDefaults.standard.set(true, forKey: "signin")
            completion(nil)
            
        }
    }
    
    
    func signOut() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
        UserDefaults.standard.set(false, forKey: "signin")
    }
    
    // Generate a random nonce string for security
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}


// MARK: - Apple Sign In Coordinator
class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private let completion: (Error?) -> Void
    private let currentNonce: String
    
    init(completion: @escaping (Error?) -> Void, nonce: String) {
        self.completion = completion
        self.currentNonce = nonce
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                completion(NSError(domain: "AppleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"]))
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                completion(NSError(domain: "AppleSignInError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to serialize token string"]))
                return
            }
            
            // Initialize a Firebase credential using OAuthProvider.appleCredential
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                         rawNonce: currentNonce,
                                                         fullName: appleIDCredential.fullName)
            
            // Sign in with Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else {
                    self.completion(error)
                    return
                }
                
                print("Apple Sign in successful")
                UserDefaults.standard.set(true, forKey: "signin")
                // ✅ Trigger instant UI update
                    DispatchQueue.main.async {
                        self.completion(nil)
                    }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
        completion(error)
    }
}
