import SwiftUI
import Firebase

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
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
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
                            } else {
                                // Handle successful sign-up (optional)
                            }
                        }
                    } else {
                        authViewModel.signIn(email: email, password: password) { error in
                            if let error = error {
                                print("Error signing in: \(error.localizedDescription)")
                            } else {
                                // Handle successful sign-in
                                isLoggedIn = true
                            }
                        }
                    }
                }) {
                    Text(isSignUp ? "Sign Up" : "Sign In")
                }
                .padding()
                NavigationLink(destination: MainView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Sign in" : "Don't have an account? Sign up")
                }
            }
            .padding()
            .navigationBarTitle("Authentication")
        }
    }
}

// SplashScreen to MainView


struct MainView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome!")
                    .padding()
                NavigationLink(destination:SplashScreen()) {
                    Text("Go to App")
                }
                .padding()
                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Sign Out")
                }
                .padding()
            }
            .navigationBarTitle("Main View")
        }
    }
}

// Preview
#if DEBUG
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
#endif

