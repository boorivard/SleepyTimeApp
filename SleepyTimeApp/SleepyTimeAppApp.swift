//
//  SleepyTimeAppApp.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 2/18/24.
//
//  Function that runs the app

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

//basic firebase setup, WIP
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
            return true
    }
}

//Running the app
@main struct SleepyTimeAppApp: App {
    init() {
            FirebaseApp.configure() // Configure Firebase before anything else
        }
    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            AuthenticationView() // Show AuthenticationView initially
                .environmentObject(authViewModel)
        }
    }
}
