//
//  JHEndpoint.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 2/10/24.
//


import Foundation

/// API Endpoints
@frozen enum JHEndpoint: String, CaseIterable, Hashable {
    /// endpoint to customer
    case customers
    /// endpoint for auth
    case auth
    /// endpoint for projects
    case projects
    /// custom case name for project-category-detail
    case projectCategoryDetails

    /// endpoint for payments
    case payments
    
    /// Computed property to handle custom raw values for endpoints
    var rawValue: String {
        switch self {
        case .projectCategoryDetails:
            return "project-category-details"
        default:
            return String(describing: self)
        }
    }
}
