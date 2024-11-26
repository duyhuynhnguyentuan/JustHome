//
//  JustHomeApp.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 2/10/24.
//

import SwiftUI
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import StripeCore

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    /// var app: used to access functions written inside JustHomeApp
    var app: JustHomeApp?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ((app?.clearKeychainIfWillUnistall()) != nil)
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate{
    /// if the user interact with the response, the func is triggred and the response didReceived is used to extract infomation
    /// - Parameters:
    ///   - center:
    ///   - response: the response from the notification (which includes infos like: link,title,...)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
        if let deeplink = response.notification.request.content.userInfo["link"] as? String,
           let url = URL(string: deeplink) {
            print("Received deeplink url: \(url)")
            Task{
                await app?.handleDeeplinking(from: url)
            }
        }
    }
    //this with the will present parameter is used to handle notification whilst your app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .sound, .list]
    }
}
extension AppDelegate: MessagingDelegate{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Task {
             await KeychainService.shared.save(token: fcmToken!, forKey: "fcmToken")
             
             // Check if there's a JWT token available
             if let jwtToken = KeychainService.shared.retrieveToken(forKey: "authToken"), !jwtToken.isEmpty {
                 // Update FCM token to the server
                 try? await app!.authService.updateToken(JWTtoken: jwtToken, FCMToken: fcmToken!)
             }
         }
         #if DEBUG
       
        print("FCM Token: \(fcmToken ?? "")")
        #endif
        
    }
}

@main
struct JustHomeApp: App {
    /// connect to the app delegate
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject var authService = AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient())
    @StateObject private var dataController = DataController()
    @StateObject private var routerManager = NavigationRouter()
    var body: some Scene {
        WindowGroup {
            ContentView(authService: self.authService)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(routerManager)
                .onAppear{
                    appDelegate.app = self
                }
                .onOpenURL { url in
                    let stripeHandled = StripeAPI.handleURLCallback(with: url)
                           if (!stripeHandled) {
                               Task{
                                   print(url)
                                   await handleDeeplinking(from: url)
                               }
                           }
                }
        }
    }
}

private extension JustHomeApp {
    //hnadle deeplink
    func handleDeeplinking(from url: URL) async {
        let routeFinder = RouteFinder()
        if let route = await routeFinder.find(from: url, projectService: ProjectsService(httpClient: HTTPClient())) {
            routerManager.push(to: route)
        }
    }
    //clear all the keychain
    func clearKeychainIfWillUnistall() {
    let freshInstall = !UserDefaults.standard.bool(forKey: "alreadyInstalled")
     if freshInstall {
             KeychainService.shared.clearAllKeys()
        UserDefaults.standard.set(true, forKey: "alreadyInstalled")
      }
    }
}

