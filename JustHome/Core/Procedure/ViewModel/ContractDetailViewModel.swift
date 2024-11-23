//
//  ContractDetailViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/11/24.
//

import Foundation

enum ContractsStatus: String, CaseIterable {
    case choxacnhanTTDG = "Chờ xác nhận TTDG"
    case choxacnhanTTDC = "Chờ xác nhận TTĐC"
    case daxacnhanTTDC = "Đã xác nhận TTĐC"
    case daxacnhanchinhsachbanhang = "Đã xác nhận chính sách bán hàng"
    case daxacnhanphieutinhgia = "Đã xác nhận phiếu tính giá"
    case dathanhtoandot1hopdongmuaban = "Đã thanh toán đợt 1 hợp đồng mua bán"
    case daxacnhanhopdongmuaban = "Đã xác nhận hợp đồng mua bán"
    case dabangiaoquyensohuudat = "Đã bàn giao quyền sở hữu đất"
    case choxacnhanTTCN = "Chờ xác nhận TTCN"
    case daxacnhanchuyennhuong = "Đã xác nhận chuyển nhượng"
    case choxacnhanTTCNTTDC = "Chờ xác nhận TTCNTTDC"
    case dahuy = "Đã hủy"
}
class ContractDetailViewModel: ObservableObject {
    let contractID: String
    let contractsService: ContractsService
    @Published private(set) var contractTitle: ContractTitleResponse?
    @Published private(set) var contract: Contract?
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    var contractStatus: ContractsStatus? {
        guard let statusText = contract?.status else { return nil }
        return ContractsStatus(rawValue: statusText)
    }
    init(contractID: String, contractsService: ContractsService) {
        self.contractID = contractID
        self.contractsService = contractsService
        loadData()
    }
    @MainActor
    func loadAContract(by contractID: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let contract = try await contractsService.loadAContract(by: contractID)
            self.contract = contract
            try await loadTitleContract(by: contractID)
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    @MainActor
    func loadTitleContract(by contractID: String) async throws{
        do{
            let contractTitleResponse = try await contractsService.loadTitleContract(by: contractID)
            self.contractTitle = contractTitleResponse
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func loadData(){
        Task{
            try await loadAContract(by: contractID)
        }
    }
    @MainActor
    func handleRefresh() {
        self.contract = nil
        loadData()
    }
}

