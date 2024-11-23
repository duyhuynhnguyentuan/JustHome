//
//  ContractPaymentDetailViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import Foundation

class ContractPaymentDetailViewModel: ObservableObject {
    let contractID: String
    let contractPaymentDetailService: ContractPaymentDetailService
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    @Published private(set) var contractPaymentDetails = [ContractPaymentDetail]()
    init(contractID: String, contractPaymentDetailService: ContractPaymentDetailService) {
        self.contractID = contractID
        self.contractPaymentDetailService = contractPaymentDetailService
        loadData()
    }
    @MainActor
    func getContractPaymentDetailList(contractID: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let contractPaymentDetails = try await contractPaymentDetailService.getContractPaymentDetail(by: contractID)
            self.contractPaymentDetails = contractPaymentDetails
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        Task{
            try await getContractPaymentDetailList(contractID: contractID)
        }
    }
}
