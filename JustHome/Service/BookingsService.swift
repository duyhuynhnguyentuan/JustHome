//
//  BookingsService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/10/24.
//


import Foundation

struct CreateBookingResponse: Codable{
    let message: String
}
protocol BookingsServiceProtocol {
    ///Create a new booking
    func createBooking(categoryDetailID: String, customerID: String) async throws -> CreateBookingResponse
    ///Load Booking by customerID
    func loadBooking(by customerID: String) async throws -> [Bookings]
    ///get a booking by bookingID
    func loadABooking(by customerID: String) async throws -> Bookings
    ///Mark customer as checked in
    func checkingIn(by booking: String) async throws -> MessageResponse
}

class BookingsService: BookingsServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient){
        self.httpClient = httpClient
    }
    /// Create a new booking
    /// - Parameters:
    ///   - propertyCategoryID: propertyCategoryID
    ///   - projectID: projectID
    ///   - customerID: customerID
    /// - Returns: response
    func createBooking(categoryDetailID: String, customerID: String) async throws -> CreateBookingResponse {
        let createBookingRequest = JHRequest(endpoint: .bookings, queryParameters: [
            URLQueryItem(name: "categoryDetailID", value: categoryDetailID),
            URLQueryItem(name: "customerID", value: customerID)
        ])
        let createBookingResource = Resource(url: createBookingRequest.url!, method: .post(nil), modelType: CreateBookingResponse.self)
        let createBookingResponse = try await httpClient.load(createBookingResource)
        if createBookingResponse.message == "Create Booking Successfully" {
            return createBookingResponse
        }else{
            throw NetworkError.errorResponse(ErrorResponse(message: createBookingResponse.message))
        }
    }
    
    /// loads bookings made by a customer
    /// - Parameter customerID: customerID
    /// - Returns: list of Bookings
    func loadBooking(by customerID: String) async throws -> [Bookings] {
        let loadBookingRequest = JHRequest(endpoint: .bookings, pathComponents: ["customer", customerID])
        let loadBookingResource = Resource(url: loadBookingRequest.url!, modelType: [Bookings].self)
        let loadBookingResponse = try await httpClient.load(loadBookingResource)
        return loadBookingResponse
    }
    func loadABooking(by bookingID: String) async throws -> Bookings {
        let loadABookingRequest = JHRequest(endpoint: .bookings, pathComponents: [bookingID])
        let loadABookingResource = Resource(url: loadABookingRequest.url!, modelType: Bookings.self)
        let loadABookingResponse = try await httpClient.load(loadABookingResource)
        return loadABookingResponse
    }
    
    func checkingIn(by bookingID: String) async throws -> MessageResponse {
        let checkingInRequest = JHRequest(endpoint: .bookings, pathComponents: [bookingID, "check-in"])
        let checkingInResource = Resource(url: checkingInRequest.url!,method: .put(nil), modelType: MessageResponse.self)
        let checkingInResponse = try await httpClient.load(checkingInResource)
        return checkingInResponse
    }
    
}

