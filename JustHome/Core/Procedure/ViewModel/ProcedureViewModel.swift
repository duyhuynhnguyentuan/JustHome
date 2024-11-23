//
//  ProcedureViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/11/24.
//

import Foundation

class ProcedureViewModel: ObservableObject {
    @Published var biometricError: BiometricError?
    @Published var searchText: String = ""
    @Published var error: NetworkError?
    @Published private(set) var loadingState: LoadingState = .idle
    let contractsService: ContractsService
    @Published private(set) var contracts = [ContractByCustomerIDResponse]()
    let customerID: String
    let biometricService: BiometricService
    init(contractsService: ContractsService, biometricService: BiometricService) {
        self.biometricService = biometricService
        self.contractsService = contractsService
        self.customerID =  KeychainService.shared.retrieveToken(forKey: "customerID") ?? ""
        loadData()
    }
    var filteredContract: [ContractByCustomerIDResponse] {
        var contract = self.contracts

           if searchText.count > 0 {
               contract = contract.filter { $0.projectName.localizedCaseInsensitiveContains(searchText) }
           }
        return contract
       }
    @MainActor
    func loadContract(by customerID: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let contracts = try await contractsService.loadContracts(by: customerID)
            self.contracts = contracts
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func authenticateWithBiometrics() throws {
        loadingState = .loading
        biometricService.requestBiometricUnlock { [weak self] result in
            switch result {
            case .success:
                self!.loadingState = .finished
                // Use credentials as needed
            case .failure(let error):
                print("Biometric authentication failed: \(error.localizedDescription)")
                self?.biometricError = error
               
            }
        }
    }
    func loadData(){
        Task(priority: .medium){
            try await loadContract(by: customerID)
        }
    }
    @MainActor
    func handleRefresh() {
        contracts.removeAll()
        loadData()
    }
}
