//
//  AuthService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 3/10/24.
//

import Foundation

//MARK: - Reponse and body model

struct AuthResponse: Codable {
    let token: String
}
struct TokenParserResonse: Codable {
    let accountID: String
    let email: String
    let roleName: String
}

struct LoginBody: Codable {
    let emailOrPhone: String
    let password: String
}
struct RegisterBody: Codable {
    let email: String
    let password: String
    let confirmPass: String
    let fullName: String
    let dateOfBirth: String
    let phoneNumber: String
    let identityCardNumber: String?
    let nationality: String
    let placeOfOrigin: String?
    let placeOfResidence: String?
    let dateOfExpiry: String?
    let taxcode: String?
    let bankName: String?
    let bankNumber: String?
    let address: String
}

struct CustomerResponse: Codable {
    let customerID: String
    let fullName: String
    let dateOfBirth: String
    let phoneNumber: String
    let identityCardNumber: String?
    let nationality: String
    let placeofOrigin: String?
    let placeOfResidence: String?
    let dateOfExpiry: String?
    let taxcode: String?
    let bankName: String?
    let bankNumber: String?
    let address: String
    let status: Bool
    let accountID: String
    let email: String
}
//MARK: - Main functionalities
protocol AuthServiceProtocol {
    func login(body: LoginBody) async throws
    func register(body: RegisterBody) async throws
    func updateToken(JWTtoken: String, FCMToken: String) async throws
}

class AuthService: AuthServiceProtocol, ObservableObject {
    @Published var isAuthenticated: Bool = false
    private let keychainService: KeychainService
    let httpClient: HTTPClient
    init(keychainService: KeychainService, httpClient: HTTPClient) {
        self.keychainService = keychainService
        self.httpClient = httpClient
        // Retrieve token from Keychain
            if let token = keychainService.retrieveToken(forKey: "authToken") {
                // Set isAuthenticated to true if a valid token exists
                isAuthenticated = !token.isEmpty
            }
        
                
    }
    @MainActor
    func getCustomer(accountId: String) async throws {
        let getCustomerRequest = JHRequest(endpoint: .customers, pathComponents: ["account", accountId])
        let getCustomerResource = Resource(url: getCustomerRequest.url!, modelType: CustomerResponse.self)
        let getCustomerResponse = try await httpClient.load(getCustomerResource)
        await keychainService.save(token: getCustomerResponse.customerID, forKey: "customerID")
    }
    @MainActor
    func tokenParser(token: String) async throws{
        print("tokenParser has received token: \(token)")
        let tokenParserRequest = JHRequest(endpoint: .auth,
                                           pathComponents: ["token", "parse"],
                                           queryParameters: [URLQueryItem(name: "token", value: token)]
        )
        print("DEBUG: token parser request: \(tokenParserRequest.url!)")
        let tokenParserResource = Resource(url: tokenParserRequest.url!, modelType: TokenParserResonse.self)
        let tokenParserResponse = try await httpClient.load(tokenParserResource)
        print("DEBUG: Token parser response: \(tokenParserResponse.email)")
//        await keychainService.save(token: tokenParserResponse.accountID, forKey: "accountID")
//        await keychainService.save(token: tokenParserResponse.email, forKey: "email")
//        await keychainService.save(token: tokenParserResponse.roleName, forKey: "roleName")
        try await getCustomer(accountId: tokenParserResponse.accountID)
        
    }
    @MainActor
    func login(body: LoginBody) async throws{
        guard let jsonData = try? JSONEncoder().encode(body) else {
            print("DEBUG: Error in decoding jsonData in Login Body")
            return
        }
        let authRequest = JHRequest(endpoint: .auth, pathComponents: ["login"])
        let authResource = Resource(url: authRequest.url!,method: .post(jsonData), modelType: AuthResponse.self)
        let result = try await httpClient.load(authResource)
        if !result.token.isEmpty {
//            isAuthenticated = true
            print("DEBUG: Receiving token: \(result.token)")
        }
        
        await keychainService.save(token: result.token, forKey: "authToken");
        try await tokenParser(token: result.token);
        if let fcmToken = keychainService.retrieveToken(forKey: "fcmToken"), !fcmToken.isEmpty {
                   try await updateToken(JWTtoken: result.token, FCMToken: fcmToken)
               }
        ///đợi mấy cái trên xong hết r mới authenticate
        isAuthenticated = true
    }
    
    @MainActor
    func register(body: RegisterBody) async throws {
        guard let jsonData = try? JSONEncoder().encode(body) else {
            print("DEBUG: Error in decoding jsonData in Register Body")
            return
        }
        let customerRegisterRequest = JHRequest.listCustomersRequest
        let customerRegisterResource = Resource(url: customerRegisterRequest.url!, method: .post(jsonData),modelType: MessageResponse.self)
        print(customerRegisterRequest)
        let result = try await httpClient.load(customerRegisterResource)
        print("DEBUG: Register Result: \(result)")
        if result.message != nil {
            try await login(body: LoginBody(emailOrPhone: body.email, password: body.password))
        }
    }
    
    @MainActor
    func updateToken(JWTtoken: String, FCMToken: String) async throws {
        let updateFCMRequest = JHRequest(endpoint: .customers, pathComponents: ["device-token"], queryParameters: [
            URLQueryItem(name: "tokenJWT", value: JWTtoken),
            URLQueryItem(name: "deviceToken", value: FCMToken)
        ])
        let updateFCMResource = Resource(url: updateFCMRequest.url!,method: .put(nil), modelType: MessageResponse.self)
        let result = try await httpClient.load(updateFCMResource)
        print("DEBUG: Update FCM Result: \(result.message ?? "empty message")")
    }
    @MainActor
    func logout() {
        self.isAuthenticated = false
            keychainService.clearAllKeys()
    }
}

