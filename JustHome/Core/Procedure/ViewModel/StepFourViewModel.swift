//
//  StepFourViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 21/11/24.
//

import Foundation

class StepFourViewModel: ObservableObject {
    let contractId: String
    let contractsService: ContractsService
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    @Published private(set) var stepFourResponse: Customer?
    init(contractId: String, contractsService: ContractsService) {
        self.contractId = contractId
        self.contractsService = contractsService
        loadData()
    }
    @MainActor
    func loadStepFourContract(by contractID: String) async throws {
        defer {loadingState = .finished}
        do{
            loadingState = .loading
            let response = try await contractsService.loadStepFourContract(by: contractID)
            self.stepFourResponse = response
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    @MainActor
    func checkStepFourContract(by contractID: String) async throws -> MessageResponse {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let response = try await contractsService.checkStepFourContract(by: contractID)
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
    func loadData() {
        Task {
            try await loadStepFourContract(by: contractId)
        }
    }
    @MainActor
    func handleRefresh(){
        loadData()
    }
}
