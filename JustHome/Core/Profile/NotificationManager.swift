//
//  NotificationManager.swift
//  Introduction_to_NavigationStackApp
//
//  Created by Huynh Nguyen Tuan Duy on 25/9/24.
//

import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    @Published private(set) var hasPermission = false
    init() {
        Task{
            await getAuthStatus()
        }
    }
    func request() async {
        do{
            self.hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        }catch {
            print(error)
        }
    }
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized,
             .provisional,
             .ephemeral:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
}
