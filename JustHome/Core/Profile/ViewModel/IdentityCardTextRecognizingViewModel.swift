//
//  IdentityCardTextRecognizingViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 5/11/24.
//

import Foundation

class IdentityCardTextRecognizingViewModel: ObservableObject {
    let customerService: CustomerService
    let customerID: String
   
    
    init(customerService: CustomerService) {
        self.customerService = customerService
        self.customerID =  KeychainService.shared.retrieveToken(forKey: "customerID") ?? ""
    }

    @MainActor
    func updateCustomerInfo(details: (cardNumber: String?, placeOfOrigin: String?, placeOfResidence: String?, expiryDate: String?), bankNumber: String, bankName: String, taxCode: String) async {
        do {
            print("DETAILS \(details)")
            // Step 1: Load current customer data
            var customer = try await customerService.loadCustomer(by: customerID)
            
            // Step 2: Update with new information
            customer.identityCardNumber = details.cardNumber!
            customer.placeOfOrigin = details.placeOfOrigin!
            customer.placeOfResidence = details.placeOfResidence!
            customer.dateOfExpiry = details.expiryDate!
            customer.bankNumber = bankNumber
            customer.bankName = bankName
            customer.taxcode = taxCode
            print("CR: \(customer)")
            // Step 3: Call updateCustomer to save changes
            try await customerService.updateCustomer(customer: customer)
            print("Customer information updated successfully.")
            
        } catch {
            print("Failed to update customer information: \(error)")
        }
    }
}
