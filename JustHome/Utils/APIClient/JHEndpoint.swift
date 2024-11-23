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
    /// endpoint for open for sale
    case openForSales
    ///endpoints for bookings
    case bookings
    ///endpoints for emails
    case emails
    /// endpoints for properties
    case propertys
    ///endpoints contract
    case contracts
    ///endpoint contractPaymentDetail
    case contractPaymentDetails
    /// Computed property to handle custom raw values for endpoints
    var rawValue: String {
        switch self {
        case .projectCategoryDetails:
            return "project-category-details"
        case .openForSales:
            return "open-for-sales"
        case .contractPaymentDetails:
            return "contract-payment-details"
        default:
            return String(describing: self)
        }
    }
}
