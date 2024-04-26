import SwiftUI
import Firebase
import FirebaseFirestore

// ViewModel to handle authentication logic
class AuthViewModel: ObservableObject {
    @State var isLoggedIn = false
    
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
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// AuthenticationView
struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @Binding var isLoggedIn: Bool
    @State private var showAlert = false
    @State private var showSUSAlert = false

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
                        handleSignUpResult(error: error)
                    }
                } else {
                    authViewModel.signIn(email: email, password: password) { error in
                        handleSignInResult(error: error)
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Account not found"), message: Text("Email or Password is incorrect."), dismissButton: .default(Text("OK")))
        }
    }

    private func handleSignInResult(error: Error?) {
                if let error = error {
                    if let errorCode = AuthErrorCode.Code(rawValue: error._code){
                        showAlert = true
                    } else {
                        print("Error signing in: \(error.localizedDescription)")
                    }
                } else {
                    Database.initDB()
                    isLoggedIn = true
                }
            }
    private func handleSignUpResult(error: Error?) {
        if let error = error {
            print("Error signing up: \(error.localizedDescription)")
        
        } else {
          
        }
    }
}
