//
//  Customer.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 11/10/24.
//

import Foundation

struct Customer: Codable, Hashable, Identifiable {
    let customerID: String
    let fullName: String
    let dateOfBirth: String
    let phoneNumber: String
    let identityCardNumber: String?
    let nationality: String
    let placeofOrigin: String?
    let placeOfResidence: String?
    let dateOfExpiry: String?
    let taxcode: String?
    let bankName: String?
    let bankNumber: String?
    let address: String
    let deviceToken: String?
    let status: Bool
    let accountID: String
    let email: String
    
    // To conform to `Identifiable`
    var id: String { customerID }
}
extension Customer {
    static var sampleCustomer = Customer(
        customerID: "238203ihfokwjdf",
        fullName: "Huynh Nguyen Tuan Duy",
        dateOfBirth: "2024-09-11",
        phoneNumber: "0835488888",
        identityCardNumber: nil,
        nationality: "Vietnam",
        placeofOrigin: nil,
        placeOfResidence: nil,
        dateOfExpiry: nil,
        taxcode: nil,
        bankName: nil,
        bankNumber: nil,
        address: "123 Nguyen Van A, Ha Noi",
        deviceToken: "ểuirun9398",
        status: true,
        accountID: "4bb91bd2-805f-4e81-ab0f-3cea4cb55855",
        email: "andyhntd2003@gmail.com"
    )
}
