//
//  TransferContractViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import Foundation

class TransferContractViewModel: ObservableObject{
    let contractId: String
    let contractsService: ContractsService
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    @Published private(set) var transfereeList = [Customer]()
    @Published var selectedTransferee: Customer?
    init(contractId: String, contractService: ContractsService){
        self.contractId = contractId
        self.contractsService = contractService
        loadData()
    }
    @MainActor
    func getTransfereeList(contractId: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let response = try await contractsService.loadCustomerTransferred(by: contractId)
            self.transfereeList = response
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    @MainActor
    func checkCustomerTransferred(customerTransfereeId: String) async throws -> MessageResponse{
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let response = try await contractsService.checkCustomerTransferred(contractId: contractId, customerTransfereeId: customerTransfereeId)
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
            try await getTransfereeList(contractId: contractId)
        }
    }
}
