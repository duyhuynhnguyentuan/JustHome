//
//  Notification.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 24/11/24.
//

import Foundation

struct Notification: Codable, Identifiable {
    var id: String {
        notificationID
    }
    let title: String
    let notificationID: String
    let subtiltle: String
    let body: String
    let createdTime: String
    let status: Bool
    let bookingID: String
    let customerID: String
    let fullName: String
}
