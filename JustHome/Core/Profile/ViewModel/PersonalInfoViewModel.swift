//
//  PersonalInfoViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 5/11/24.
//

import Foundation
@MainActor
class PersonalInfoViewModel: ObservableObject {
    @Published private(set) var customer: loadCustomerByIDResponse?
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    let customerService: CustomerService
    init(customerService: CustomerService) {
        self.customerService = customerService
        loadData()
    }
    @MainActor
    func loadCustomer(by customerID: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let customer = try await customerService.loadCustomer(by: customerID)
            self.customer = customer
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func loadData() {
        Task(priority: .medium){
            try await loadCustomer(by: KeychainService.shared.retrieveToken(forKey: "customerID") ?? "")
        }
    }
    
}