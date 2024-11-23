//
//  StepSevenViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 22/11/24.
//

import Foundation

class StepSevenViewModel: ObservableObject {
    let contractId: String
    let contractsService: ContractsService
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    @Published private(set) var stepSevenDetail: MessageResponse?
    init(contractId: String, contractsService: ContractsService){
        self.contractId = contractId
        self.contractsService = contractsService
        loadData()
    }
    
    @MainActor
    func loadStepSevenContract(by contractID: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let loadStepOneDetail = try await contractsService.loadStepSevenContract(by: contractID)
            self.stepSevenDetail = loadStepOneDetail
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func loadData(){
        Task{
            try await loadStepSevenContract(by: contractId)
        }
    }
    @MainActor
    func handleRefresh(){
        loadData()
    }
}
