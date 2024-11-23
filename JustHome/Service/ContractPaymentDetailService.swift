//
//  ContractPaymentDetailService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import Foundation
protocol ContractPaymentDetailServiceProtocol {
    func getContractPaymentDetail(by contractID: String) async throws -> [ContractPaymentDetail]
    func uploadPaymentOrder(by contractPaymentDetailID: String) async throws -> MessageResponse
}

class ContractPaymentDetailService: ContractPaymentDetailServiceProtocol{
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func getContractPaymentDetail(by contractID: String) async throws -> [ContractPaymentDetail] {
        let getContractPaymentDetailRequest = JHRequest(endpoint: .contractPaymentDetails, pathComponents: ["contract", contractID])
        let getContractPaymentDetailResource = Resource(url: getContractPaymentDetailRequest.url!, modelType: [ContractPaymentDetail].self)
        let getContractPaymentDetailResponse = try await httpClient.load(getContractPaymentDetailResource)
        return getContractPaymentDetailResponse
    }
    
    func uploadPaymentOrder(by contractPaymentDetailID: String) async throws -> MessageResponse {
        let uploadPaymentOrderRequest = JHRequest(endpoint: .contractPaymentDetails, pathComponents: ["upload-payment-order", contractPaymentDetailID])
        let uploadPaymentOrderResource = Resource(url: uploadPaymentOrderRequest.url!,method: .put(nil), modelType: MessageResponse.self)
        let uploadPaymentOrderResponse = try await httpClient.load(uploadPaymentOrderResource)
        return uploadPaymentOrderResponse
    }
    
    
}
