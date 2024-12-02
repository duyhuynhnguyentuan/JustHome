//
//  PropertyService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 8/11/24.
//

import Foundation

protocol PropertyServiceProtocol {
    func getProperty(by categoryDetail: String) async throws -> [Property]
}

class PropertyService: PropertyServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    @MainActor
    func deleteBooking(bookingID: String) async throws -> MessageResponse {
        let deleteBookingRequest = JHRequest(endpoint: .bookings, pathComponents: ["not-choose",bookingID])
        let deleteBookingResouce = Resource(url: deleteBookingRequest.url!,method: .put(nil), modelType: MessageResponse.self)
        let response = try await httpClient.load(deleteBookingResouce)
        return response
    }
    @MainActor
    func getProperty(by categoryDetailID: String) async throws -> [Property] {
        let getPropertyRequest = JHRequest(endpoint: .propertys, pathComponents: ["categoryDetail", categoryDetailID])
        let getPropertyResouce = Resource(url: getPropertyRequest.url!, modelType: [Property].self)
        let response = try await httpClient.load(getPropertyResouce)
        return response
    }
    
    @MainActor
    func getBookingDeposits(by projectCategoryDetailId: String) async throws -> Bookings {
        let getBookingDepositsRequest = JHRequest(endpoint: .bookings, pathComponents: ["deposits", projectCategoryDetailId])
        let getBookingDepositsResouce = Resource(url: getBookingDepositsRequest.url!, modelType: Bookings.self)
        let response = try await httpClient.load(getBookingDepositsResouce)
        return response
    }
    
    @MainActor
    func selectProperty(by propertyId: String, by customerID: String) async throws -> MessageResponse {
        let selectPropertyRequest = JHRequest(endpoint: .propertys, pathComponents: ["select"], queryParameters: [
            URLQueryItem(name: "propertyid", value: propertyId),
            URLQueryItem(name: "customerID", value: customerID )
        ])
        let selectPropertyResouce = Resource(url: selectPropertyRequest.url!,method: .put(nil), modelType: MessageResponse.self)
        let response = try await httpClient.load(selectPropertyResouce)
        return response
    }
}
