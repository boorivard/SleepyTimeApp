//
//  SleepyTimeAppApp.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 2/18/24.
//
//  Function that runs the app

import FirebaseCore
import FirebaseFirestore
import SwiftUI

//basic firebase setup, WIP
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      _ = Firestore.firestore()
    return true
  }
}

//Running the app
@main struct SleepyTimeAppApp: App {
   // @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
