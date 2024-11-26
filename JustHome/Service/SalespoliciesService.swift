//
//  SalespoliciesService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 25/11/24.
//

import Foundation

protocol SalespoliciesServiceProtocol {
    func loadSalesPolicys(projectID: String) async throws -> [SalesPolicy]
}

class SalespoliciesService: SalespoliciesServiceProtocol  {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func loadSalesPolicys(projectID: String) async throws -> [SalesPolicy] {
        let loadSalesPolicysRequest = JHRequest(endpoint: .salePolicies, pathComponents: ["project", projectID])
        let loadSalesPolicyResource = Resource(url: loadSalesPolicysRequest.url!, modelType: [SalesPolicy].self)
        let loadSalesPoliciesResponse = try await httpClient.load(loadSalesPolicyResource)
        return loadSalesPoliciesResponse
    }
    
}
