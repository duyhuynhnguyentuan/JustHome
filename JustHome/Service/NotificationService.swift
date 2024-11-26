//
//  NotificationService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 24/11/24.
//

import Foundation

protocol NotificationServiceProtocol {
    func loadNotification(by customerID: String) async throws -> [Notification]
}

class NotificationService: NotificationServiceProtocol {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func loadNotification(by customerID: String) async throws -> [Notification] {
        let loadNotificationRequest = JHRequest(endpoint: .notifications, pathComponents: ["customer", customerID])
        let loadNotificationResource = Resource(url: loadNotificationRequest.url!, modelType: [Notification].self)
        let loadNotificationResponse = try await httpClient.load( loadNotificationResource)
        return loadNotificationResponse
    }
    
    
}
