//
//  OpenForSaleService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/10/24.
//

import Foundation

protocol OpenForSalesServiceProtocol {
    func loadOpenForSale(projectId: String) async throws -> [OpenForSales]
    func loadOpenForSale(openForSalesID: String) async throws -> OpenForSales
}

class OpenForSaleService: OpenForSalesServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    //MARK: get opening for sale by projectID
    func loadOpenForSale(projectId: String) async throws -> [OpenForSales] {
        let loadOpenForSalesRequest = JHRequest(endpoint: .openForSales, pathComponents: ["project", projectId])
        let loadOpenForSalesResource = Resource(url: loadOpenForSalesRequest.url!, modelType: [OpenForSales].self)
        let response = try await httpClient.load(loadOpenForSalesResource)
        return response
    }
    func loadOpenForSale(openForSalesID: String) async throws -> OpenForSales {
        let loadOpenForSalebyID = JHRequest(endpoint: .openForSales,pathComponents: [openForSalesID])
        let loadOpenForSalebyIDResource = Resource(url: loadOpenForSalebyID.url!, modelType: OpenForSales.self)
        let response = try await httpClient.load(loadOpenForSalebyIDResource)
        return response
    }
    
    
}
