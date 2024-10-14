//
//  HTTPClient.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 2/10/24.
//

import Foundation

enum NetworkError: Error, Identifiable {
    case badRequest
    case decodingError(Error) // Error does not conform to Equatable
    case invalidResponse
    case errorResponse(ErrorResponse)

    var id: String {
        self.localizedDescription
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad Request (400): Unable to perform the request.", comment: "badRequestError")
        case .decodingError:
            return NSLocalizedString("Unable to decode successfully.", comment: "decodingError")
        case .invalidResponse:
            return NSLocalizedString("Invalid response.", comment: "invalidResponse")
        case .errorResponse(let errorResponse):
            return NSLocalizedString("Error \(errorResponse.message ?? "")", comment: "Error Response")
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badRequest, .badRequest):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.errorResponse(let lhsError), .errorResponse(let rhsError)):
            return lhsError.message == rhsError.message
        case (.decodingError, .decodingError):
            // You can't directly compare the `Error`, so return `false` or choose another strategy
            return false
        default:
            return false
        }
    }
}
enum HTTPMethod {
    case get
    case post(Data?)
    case delete
    case put(Data?)
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}
struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get
    var headers: [String: String]? = nil
    var modelType: T.Type
}
struct HTTPClient {
    private let session: URLSession
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }
        func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        print("DEBUG: The request url: \(resource.url.absoluteString)")
        print("DEBUG: Resource info: \(resource)")
        var request = URLRequest(url: resource.url)
        switch resource.method {
        case .get:
            request.httpMethod = resource.method.name
        case .post(let data), .put(let data):
            request.httpBody = data
            request.httpMethod = resource.method.name
        case .delete:
            request.httpMethod = resource.method.name
        }
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        if let headers = resource.headers {
                  for (key, value) in headers {
                      request.setValue(value, forHTTPHeaderField: key)
                  }
              }
              
              let (data, response) = try await session.data(for: request)
            print("request being sent: \(request)")
        print("DEBUG: Received data: \(data)")
        if let jsonString = String(data: data, encoding: .utf8) {
            print("DEBUG: Received JSON: \(jsonString)")
        } else {
            print("DEBUG: Unable to convert data to string")
        }
        
        // Print the type of data received
        print("DEBUG: Type of 'data': \(type(of: data))")
              guard let httpResponse = response as? HTTPURLResponse else {
                  throw NetworkError.invalidResponse
              }
              
              // Check for specific HTTP errors
              switch httpResponse.statusCode {
                  case 200...299:
                      break // Success
                  default:
                      let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                      throw NetworkError.errorResponse(errorResponse)
              }
              
              do {
                  let result = try JSONDecoder().decode(resource.modelType, from: data)
                  return result
              } catch {
                  throw NetworkError.decodingError(error)
              }
    }
}

struct ErrorResponse: Codable {
    let message: String?
}
