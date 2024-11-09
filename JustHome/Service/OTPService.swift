//
//  OTPService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 7/11/24.
//

import Foundation

protocol OTPServiceProtocol {
    func sendEmail(email: String) async throws -> MessageResponse
    func verifyOTP(email: String, otp: String) async throws -> MessageResponse
}

class OTPService: OTPServiceProtocol {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func sendEmail(email: String) async throws -> MessageResponse {
        let sendEmailRequest = JHRequest(endpoint: .emails,pathComponents: ["sendemail"], queryParameters: [
            URLQueryItem(name: "email", value: email)
        ])
        let sendEmailResource = Resource(url: sendEmailRequest.url! ,method: .post(nil), modelType: MessageResponse.self)
        let sendEmailResponse = try await httpClient.load(sendEmailResource)
        return sendEmailResponse
    }
    
    func verifyOTP(email: String, otp: String) async throws -> MessageResponse {
        let verifyOTPRequest = JHRequest(endpoint: .emails, pathComponents: ["verify-otp"], queryParameters: [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "otp", value: otp)
        ])
        let verifyOTPResource = Resource(url: verifyOTPRequest.url!,method: .post(nil), modelType: MessageResponse.self)
        let verifyOTPResponse = try await httpClient.load(verifyOTPResource)
        return verifyOTPResponse
    }
    
    
}
