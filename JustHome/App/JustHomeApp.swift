//
//  JustHomeApp.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 2/10/24.
//

import SwiftUI

class AppDelgate: NSObject, UIApplicationDelegate, ObservableObject {
    
    /// var app: used to access functions written inside JustHomeApp
    var app: JustHomeApp?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ((app?.clearKeychainIfWillUnistall()) != nil)
    }
}

@main
struct JustHomeApp: App {
    /// connect to the app delegate
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelgate
    @StateObject var authService = AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient())
    @StateObject private var routerManager = NavigationRouter()
    var body: some Scene {
        WindowGroup {
            ContentView(authService: self.authService)
                .environmentObject(routerManager)
                .onAppear{
                    appDelegate.app = self
                }
        }
    }
}

private extension JustHomeApp {
    func clearKeychainIfWillUnistall() {
    let freshInstall = !UserDefaults.standard.bool(forKey: "alreadyInstalled")
     if freshInstall {
         KeychainService.shared.clearAllKeys()
        UserDefaults.standard.set(true, forKey: "alreadyInstalled")
      }
    }
}

