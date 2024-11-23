//
//  StepThreeViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 20/11/24.
//

import Foundation

class StepThreeViewModel: ObservableObject {
    let contractId: String
    let contractsService: ContractsService
    @Published private(set) var stepThreeContract: PromotionAndPaymentResponse?
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    init(contractID: String, contractsService: ContractsService) {
        self.contractsService = contractsService
        self.contractId = contractID
        loadData()
    }
    // xac nhan buoc 3
    @MainActor
    func loadStepThreeContract(by contractID: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let loadStepThreeContract = try await contractsService.loadStepThreeContract(by: contractID)
            self.stepThreeContract = loadStepThreeContract
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    @MainActor
    func checkStepThreeContract(contractID: String, promotionDetailID: String, paymentProcessID: String) async throws -> MessageResponse{
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let response = try await contractsService.checkStepThreeContract(by: contractID, promotiondetailid: promotionDetailID, paymentprocessid: paymentProcessID)
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
    
    func loadData(){
        Task{
            try await loadStepThreeContract(by: contractId)
        }
    }
    @MainActor
    func handleRefresh(){
        self.stepThreeContract = nil
        loadData()
    }
}
