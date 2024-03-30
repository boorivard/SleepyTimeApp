//
//  SleepyTimeAppApp.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 2/18/24.
//

import FirebaseCore
import FirebaseFirestore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      _ = Firestore.firestore()
    return true
  }
}
//Jared Rivard's code is here
@main struct SleepyTimeAppApp: App {
   // @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
}
