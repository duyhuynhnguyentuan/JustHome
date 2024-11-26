//
//  NotificationViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 24/11/24.
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState = .idle
    @Published private(set) var notifications = [Notification]()
    @Published var error: NetworkError?
    let notificationService: NotificationService
    let customerId: String
    init(notificationService: NotificationService){
        self.notificationService = notificationService
        self.customerId =  KeychainService.shared.retrieveToken(forKey: "customerID") ?? ""
    }
    
    @MainActor
    func loadNotifications() async throws{
        defer {loadingState = .finished }
        do{
            loadingState = .loading
            let notifications = try await notificationService.loadNotification(by: customerId)
            self.notifications = notifications
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func loadData(){
        Task(priority: .medium){
            try await loadNotifications()
        }
    }
    @MainActor
    func handleRefresh(){
        notifications.removeAll()
        loadData()
    }
}
