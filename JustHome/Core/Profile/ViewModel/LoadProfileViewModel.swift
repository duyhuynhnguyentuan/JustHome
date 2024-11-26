//
//  LoadProfileViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/11/24.
//

import Foundation
class LoadProfileViewModel: ObservableObject {
    let customerService: CustomerService
    let customerID: String
    
    init(customerService: CustomerService) {
        self.customerService = customerService
        self.customerID =  KeychainService.shared.retrieveToken(forKey: "customerID") ?? ""
    }
    @MainActor
    func updateProfile(fullName: String, dateOfBirth: String, phoneNumber: String, nationality: String, address: String) async throws {
        do{
            var customer = try await customerService.loadCustomer(by: customerID)
            customer.fullName = fullName
            customer.dateOfBirth = dateOfBirth
            customer.phoneNumber = phoneNumber
            customer.nationality = nationality
            customer.address = address
            try await customerService.updateCustomer(customer: customer)
            
        }catch {
            print("Failed to update customer information: \(error)")
        }
    }
}
