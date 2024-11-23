//
//  ConfirmReceiveContractViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import Foundation

class ConfirmReceiveContractViewModel: ObservableObject {
    let contractId: String
    let contractsService: ContractsService
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    init(contractId: String, contractsService: ContractsService) {
        self.contractId = contractId
        self.contractsService = contractsService
    }
    @MainActor
    func confirmReceiveContract() async throws -> MessageResponse {
        defer {loadingState = .finished }
        do{
            loadingState = .loading
            let response = try await contractsService.checkReceivedTransfer(contractID: contractId)
            return response
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
            throw error
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            throw error
        }
        
    }
}
