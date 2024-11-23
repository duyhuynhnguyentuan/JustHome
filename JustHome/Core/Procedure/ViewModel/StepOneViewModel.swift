//
//  StepOneViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/11/24.
//

import Foundation

class StepOneViewModel: ObservableObject {
    let contractId: String
    let contractsService: ContractsService
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    @Published private(set) var stepOneContractDetail: ContractStepOneResponse?
    init(contractId: String, contractsService: ContractsService) {
        self.contractId = contractId
        self.contractsService = contractsService
        loadData()
    }
    //Xác nhận thông tin bước 1
    @MainActor
    func checkStepOneContract(by contractID: String) async throws -> MessageResponse {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let response = try await contractsService.checkStepOneContract(by: contractID)
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
    @MainActor
    func loadStepOneContract(by contractID: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let loadStepOneDetail = try await contractsService.loadStepOneContract(by: contractID)
            self.stepOneContractDetail = loadStepOneDetail
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        Task{
            try await loadStepOneContract(by: contractId)
        }
    }
    @MainActor
    func handleRefresh(){
        self.stepOneContractDetail = nil
        loadData()
    }
    
}
