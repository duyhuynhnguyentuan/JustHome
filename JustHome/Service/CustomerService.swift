//
//  CustomerService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 5/11/24.
//

import Foundation
//fullName, dateOfBirth, phoneNumer, nationality, address
struct loadCustomerByIDResponse: Codable {
    var customerID: String
    var fullName: String
    var dateOfBirth: String
    var phoneNumber: String
    var identityCardNumber: String?
    var nationality: String
    var placeofOrigin: String?
    var placeOfResidence: String?
    var dateOfExpiry: String?
    var taxcode: String?
    var bankName: String?
    var bankNumber: String?
    var address: String
    var deviceToken: String?
    var status: Bool
    var accountID: String
    var email: String
}

protocol CustomerServiceProtocol {
    func loadCustomer(by customerID: String) async throws -> loadCustomerByIDResponse
    func updateCustomer(customer: loadCustomerByIDResponse) async throws
}

class CustomerService: CustomerServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func loadCustomer(by customerID: String) async throws -> loadCustomerByIDResponse {
        let loadCustomerRequest = JHRequest(endpoint: .customers, pathComponents: [customerID])
        let loadCustomerResource = Resource(url: loadCustomerRequest.url!, modelType: loadCustomerByIDResponse.self)
        return try await httpClient.load(loadCustomerResource)
    }

//    func updateCustomer(customer: loadCustomerByIDResponse) async throws {
//        print("DEBUG in update customer: \(customer)")
//        guard let jsonData = try? JSONEncoder().encode(customer) else {
//            print("DEBUG: Error in decoding jsonData in update customer Body")
//            return
//        }
//        if let jsonString = String(data: jsonData, encoding: .utf8) {
//              print("JSON Data: \(jsonString)")
//          } else {
//              print("DEBUG: Could not convert jsonData to String")
//          }
//        let updateCustomerRequest = JHRequest(endpoint: .customers, pathComponents: [customer.customerID])
//        print("DUMA: \(jsonData)")
//        let updateCustomerResource = Resource(url: updateCustomerRequest.url!, method: .put(jsonData), modelType: MessageResponse.self)
//        _ = try await httpClient.load(updateCustomerResource)
//    }
}


// Update to only include necessary fields in the update request

extension CustomerService {
    func updateCustomer(customer: loadCustomerByIDResponse) async throws {
        print("DEBUG in update customer: \(customer)")

        // Set up boundary for the multipart request
        let boundary = UUID().uuidString
        var requestBody = Data()

        // Helper function to add fields to request body
        func addField(name: String, value: String) {
            requestBody.append("--\(boundary)\r\n")
            requestBody.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            requestBody.append("\(value)\r\n")
        }

        // Add only the necessary fields to the request body
        addField(name: "FullName", value: customer.fullName)
        addField(name: "DateOfBirth", value: customer.dateOfBirth)
        addField(name: "PhoneNumber", value: customer.phoneNumber)
        addField(name: "IdentityCardNumber", value: customer.identityCardNumber!)
        addField(name: "Nationality", value: customer.nationality)
        addField(name: "PlaceofOrigin", value: customer.placeofOrigin!)
        addField(name: "PlaceOfResidence", value: customer.placeOfResidence!)
        addField(name: "DateOfExpiry", value: customer.dateOfExpiry!)
        addField(name: "Taxcode", value: customer.taxcode!)
        addField(name: "BankName", value: customer.bankName!)
        addField(name: "BankNumber", value: customer.bankNumber!)
        addField(name: "Address", value: customer.address)
        addField(name: "DeviceToken", value: customer.deviceToken!)
        addField(name: "Status", value: "\(customer.status)")

        // End boundary
        requestBody.append("--\(boundary)--\r\n")

        // Create URLRequest
        let updateCustomerRequest = JHRequest(endpoint: .customers, pathComponents: [customer.customerID])
        var request = URLRequest(url: updateCustomerRequest.url!)
        request.httpMethod = "PUT"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        // Send the request using URLSession
        let (data, response) = try await URLSession.shared.data(for: request)

        // Verify response
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }

        // Decode response
        do {
            let messageResponse = try JSONDecoder().decode(MessageResponse.self, from: data)
            print("Update successful: \(messageResponse.message ?? "No message")")
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
}

// Helper extension to add strings to Data
extension Data {
    mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
