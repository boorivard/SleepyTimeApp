//
//  AuthenticationView.swift
//  SleepyTimeApp
//
//  Created by Justin Gherman on 4/18/24.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

#Preview {
    AuthenticationView()
}

// ViewModel to handle authentication logic
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    func listenForAuthChanges() {
        Auth.auth().addStateDidChangeListener { (_, user) in
            self.isLoggedIn = user != nil
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            completion(error)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user : \(error.localizedDescription)")
            } else {
                let user = authResult?.user
            }
        }
        
        func signOut() {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
}
    // AuthenticationView
    struct AuthenticationView: View {
        @EnvironmentObject var authViewModel: AuthViewModel
        @State private var email = ""
        @State private var password = ""
        @State private var isSignUp = false
        
        var body: some View {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    if isSignUp {
                        authViewModel.signUp(email: email, password: password) { error in
                            if let error = error {
                                print("Error signing up: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        authViewModel.signIn(email: email, password: password) { error in
                            if let error = error {
                                print("Error signing in: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    Text(isSignUp ? "Sign Up" : "Sign In")
                }
                .padding()
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Sign in" : "Don't have an account? Sign up")
                }
            }
            .padding()
        }
    }
    
    // SplashScreen to MainView
    struct MainView: View {
        @EnvironmentObject var authViewModel: AuthViewModel
        
        var body: some View {
            Text("Welcome!")
                .padding()
            Button(action: {
                
            }) {
                Text("Sign Out")
            }
            .padding()
        }
    }
