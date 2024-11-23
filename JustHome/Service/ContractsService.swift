//
//  ContractsService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 17/11/24.
//

import Foundation

protocol ContractsServiceProtocol {
    func loadContracts(by customerID: String) async throws -> [ContractByCustomerIDResponse]
    func loadAContract(by contractID: String) async throws -> Contract
    func loadStepOneContract(by contractID: String) async throws -> ContractStepOneResponse
    func checkStepOneContract(by contractID: String) async throws -> MessageResponse
    func loadTitleContract(by contractID: String) async throws -> ContractTitleResponse
    func stepTwoSendOTP(by contractid: String) async throws -> MessageResponse
    func stepTwoVerifyOTP(by contractid: String, otp: String) async throws -> MessageResponse
    func loadStepThreeContract(by contractID: String) async throws -> PromotionAndPaymentResponse
    func checkStepThreeContract(by contractID: String, promotiondetailid: String, paymentprocessid: String) async throws -> MessageResponse
    func loadStepFourContract(by contractID: String) async throws -> Customer
    func checkStepFourContract(by contractID: String) async throws -> MessageResponse
    func loadStepSixSendOTP(by contractID: String) async throws -> MessageResponse
    func stepSixVerifyOTP(by contractID: String, otp: String) async throws -> MessageResponse
    func loadStepSevenContract(by contractID: String) async throws -> MessageResponse
    ///load list of customer than can be transffered to
    func loadCustomerTransferred(by contractID: String) async throws -> [Customer]
    /// khách hàng muốn chuyển nhượng xác nhận chuyển nhượng
    func checkCustomerTransferred(contractId: String, customerTransfereeId: String) async throws -> MessageResponse
    func checkTransferSendOTP(contractID: String) async throws -> MessageResponse
    func checkTransferVerifyOTP(contractID: String, otp: String) async throws -> MessageResponse
    func checkReceivedTransfer(contractID: String) async throws -> MessageResponse
}

class ContractsService: ContractsServiceProtocol {
    func loadCustomerTransferred(by contractID: String) async throws -> [Customer] {
        let loadCustomerTransfferedRequest = JHRequest(endpoint: .contracts, pathComponents: ["customer-transferred", contractID])
        let loadCustomerTransferredResource = Resource(url: loadCustomerTransfferedRequest.url!, modelType: [Customer].self)
        let loadCustomerTransfferedResponse = try await httpClient.load(loadCustomerTransferredResource)
        return loadCustomerTransfferedResponse
    }
    
    func checkCustomerTransferred(contractId: String, customerTransfereeId: String) async throws -> MessageResponse {
        let checkCustomerTransfferedRequest = JHRequest(endpoint: .contracts, pathComponents: ["check-customer-transferred"], queryParameters: [
            URLQueryItem(name: "contractId", value: contractId),
            URLQueryItem(name: "customerTransfereeId", value: customerTransfereeId)
        ])
        let checkCustomerTransfferedResource = Resource(url: checkCustomerTransfferedRequest.url!, method: .put(nil) ,modelType: MessageResponse.self)
        let checkCustomerTransfferedResponse = try await httpClient.load(checkCustomerTransfferedResource)
        return checkCustomerTransfferedResponse
    }
    
    func checkTransferSendOTP(contractID: String) async throws -> MessageResponse {
        let checkTransferSendOTPRequest = JHRequest(endpoint: .contracts, pathComponents: ["check-transfer-send-otp"],queryParameters: [
            URLQueryItem(name: "contractid", value: contractID)
        ])
        let checkTransferSendOTPResource = Resource(url: checkTransferSendOTPRequest.url!, method: .post(nil) ,modelType: MessageResponse.self)
        let checkTransferSendOTPResponse = try await httpClient.load(checkTransferSendOTPResource)
        return checkTransferSendOTPResponse
        
    }
    
    func checkTransferVerifyOTP(contractID: String, otp: String) async throws -> MessageResponse {
        let checkTransferVerifyOTPRequest = JHRequest(endpoint: .contracts, pathComponents: ["check-transfer-verify-otp"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID),
            URLQueryItem(name: "otp", value: otp)
        ])
        let checkTransferVerifyOTPResource = Resource(url: checkTransferVerifyOTPRequest.url!, method: .post(nil) ,modelType: MessageResponse.self)
        let checkTransferVerifyOTPResponse = try await httpClient.load(checkTransferVerifyOTPResource)
        return checkTransferVerifyOTPResponse
    }
    
    func checkReceivedTransfer(contractID: String) async throws -> MessageResponse {
        let checkReceivedTransferRequest = JHRequest(endpoint: .contracts, pathComponents: ["check-receive-transfer"], queryParameters: [URLQueryItem(name: "contractid", value: contractID)])
        let checkReceivedTransferResource = Resource(url: checkReceivedTransferRequest.url!, method: .put(nil), modelType: MessageResponse.self)
        let checkReceivedTransferResponse = try await httpClient.load(checkReceivedTransferResource)
        return checkReceivedTransferResponse
    }
    
    func loadStepSevenContract(by contractID: String) async throws -> MessageResponse {
        let loadStepSevenContractRequest = JHRequest(endpoint: .contracts, pathComponents: ["step-seven"], queryParameters: [URLQueryItem(name: "contractid", value: contractID)]
        )
        let loadStepSevenContractResource = Resource(url: loadStepSevenContractRequest.url!, modelType: MessageResponse.self)
        let loadStepSevenContractResponse = try await httpClient.load(loadStepSevenContractResource)
        return loadStepSevenContractResponse
    }
    
    func stepSixVerifyOTP(by contractID: String, otp: String) async throws -> MessageResponse {
        let stepSixVerifyOTPRequest = JHRequest(endpoint: .contracts, pathComponents: ["step-six-verify-otp"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID),
            URLQueryItem(name: "otp", value: otp)
        ])
        let stepSixVerifyOTPResource = Resource(url: stepSixVerifyOTPRequest.url!,method: .post(nil), modelType: MessageResponse.self)
        let stepSixVerifyOTPResponse = try await httpClient.load(stepSixVerifyOTPResource)
        return stepSixVerifyOTPResponse
    }
    
    func loadStepSixSendOTP(by contractID: String) async throws -> MessageResponse {
        let loadStepSixSendOTPRequest = JHRequest(endpoint: .contracts, pathComponents: ["step-six-send-otp"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID)
        ])
        let loadStepSixSendOTPResource = Resource(url: loadStepSixSendOTPRequest.url!,method: .post(nil), modelType: MessageResponse.self)
        let loadStepSixSendOTPResponse = try await httpClient.load(loadStepSixSendOTPResource)
        return loadStepSixSendOTPResponse
    }
    
    func checkStepFourContract(by contractID: String) async throws -> MessageResponse {
        let checkStepFourContractRequest = JHRequest(endpoint: .contracts, pathComponents: ["check-step-four"], queryParameters: [URLQueryItem(name: "contractid", value: contractID)])
        let checkStepFourContractResource = Resource(url: checkStepFourContractRequest.url!,method: .put(nil), modelType: MessageResponse.self)
        let checkStepFourContractResponse = try await httpClient.load(checkStepFourContractResource)
        return  checkStepFourContractResponse
    }
    
    func loadStepFourContract(by contractID: String) async throws -> Customer {
        let loadStepFourContract = JHRequest(endpoint: .contracts, pathComponents: ["step-four"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID)
        ])
        let loadStepFourContractResource = Resource(url: loadStepFourContract.url!, modelType: Customer.self)
        let loadStepFourContractResponse = try await httpClient.load(loadStepFourContractResource)
        return  loadStepFourContractResponse
    }
    
    func checkStepThreeContract(by contractID: String,promotiondetailid: String, paymentprocessid: String) async throws -> MessageResponse {
        let checkStepThreeContractRequest = JHRequest(endpoint: .contracts, pathComponents: ["check-step-three"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID),
            URLQueryItem(name: "promotiondetailid", value: promotiondetailid),
            URLQueryItem(name: "paymentprocessid", value: paymentprocessid)
        ])
        let checkStepThreeResource = Resource(url: checkStepThreeContractRequest.url!,method: .put(nil), modelType: MessageResponse.self)
        let checkStepThreeResponse = try await httpClient.load(checkStepThreeResource)
        return checkStepThreeResponse
    }
    
    func loadStepThreeContract(by contractID: String) async throws -> PromotionAndPaymentResponse {
        let loadStepThreeRequest = JHRequest(endpoint: .contracts, pathComponents: ["step-three"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID)
        ])
        let loadStepThreeResource = Resource(url: loadStepThreeRequest.url!, modelType: PromotionAndPaymentResponse.self)
        let loadStepThreeResponse = try await httpClient.load(loadStepThreeResource)
        return loadStepThreeResponse
    }
    
    func stepTwoVerifyOTP(by contractid: String, otp: String) async throws -> MessageResponse {
        let stepTwoVerifyOTPRequest = JHRequest(endpoint: .contracts, pathComponents: ["step-two-verify-otp"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractid),
            URLQueryItem(name: "otp", value: otp)
        ])
        let stepTwoVerifyOTPResource = Resource(url: stepTwoVerifyOTPRequest.url! ,method: .post(nil), modelType: MessageResponse.self)
        let stepTwoVerifyOTPResponse = try await httpClient.load(stepTwoVerifyOTPResource)
        return stepTwoVerifyOTPResponse
    }
    
    func stepTwoSendOTP(by contractid: String) async throws -> MessageResponse {
        let stepTwoSendOTPRequest = JHRequest(endpoint: .contracts, pathComponents: ["step-two-send-otp"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractid)
        ])
        let stepTwoSendOTPResource = Resource(url: stepTwoSendOTPRequest.url! ,method: .post(nil), modelType: MessageResponse.self)
        let stepTwoSendOTPResponse = try await httpClient.load(stepTwoSendOTPResource)
        return stepTwoSendOTPResponse
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func loadTitleContract(by contractID: String) async throws -> ContractTitleResponse {
        let loadTitleContractRequest = JHRequest(endpoint: .contracts, pathComponents: ["title-contract"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID)
        ])
        let loadTitleContractResource = Resource(url: loadTitleContractRequest.url!, modelType: ContractTitleResponse.self)
        let loadTitleContractResponse = try await httpClient.load(loadTitleContractResource)
        return loadTitleContractResponse
    }
    func loadContracts(by customerID: String) async throws -> [ContractByCustomerIDResponse] {
        let loadContractsByCustomerIDRequest = JHRequest(endpoint: .contracts, pathComponents: ["customer",customerID])
        let loadContractsByCustomerIDResource = Resource(url: loadContractsByCustomerIDRequest.url!, modelType: [ContractByCustomerIDResponse].self)
        let loadContractsByCustomerIDResponse = try await httpClient.load(loadContractsByCustomerIDResource)
        return loadContractsByCustomerIDResponse
    }
    func loadAContract(by contractID: String) async throws -> Contract {
        let loadAContractRequest = JHRequest(endpoint: .contracts, pathComponents: [contractID])
        let loadAContractResource = Resource(url: loadAContractRequest.url!, modelType: Contract.self)
        let loadAContractResponse = try await httpClient.load(loadAContractResource)
        return loadAContractResponse
    }
    
    
    func loadStepOneContract(by contractID: String) async throws -> ContractStepOneResponse {
        let loadStepOneContractRequest = JHRequest(endpoint: .contracts, pathComponents: ["step-one"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID)
        ])
        let loadStepOneContractResource = Resource(url: loadStepOneContractRequest.url!, modelType: ContractStepOneResponse.self)
        let loadStepOneContractResponse = try await httpClient.load(loadStepOneContractResource)
        return loadStepOneContractResponse
    }
    
    func checkStepOneContract(by contractID: String) async throws -> MessageResponse {
        let checkStepOneContractRequest = JHRequest(endpoint: .contracts, pathComponents: ["check-step-one"], queryParameters: [
            URLQueryItem(name: "contractid", value: contractID)
        ])
        let checkStepOneContractResource = Resource(url: checkStepOneContractRequest.url!,method: .put(nil), modelType: MessageResponse.self)
        let checkStepOneContractResponse = try await httpClient.load(checkStepOneContractResource)
        return checkStepOneContractResponse
    }
    
    
}
