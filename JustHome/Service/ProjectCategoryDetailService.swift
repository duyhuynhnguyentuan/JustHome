//
//  ProjectCategoryDetailService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/10/24.
//

import Foundation

protocol ProjectCategoryDetailServiceProtocol {
    func loadProjectCategoryDetail(projectID: String) async throws -> [ProjectCategoryDetail]
}

class ProjectCategoryDetailService: ProjectCategoryDetailServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func loadProjectCategoryDetail(projectID: String) async throws -> [ProjectCategoryDetail] {
        let loadProjectCategoryDetailRequest = JHRequest(endpoint: .projectCategoryDetails, pathComponents: ["project", projectID])
        let loadProjectCategoryDetailResource = Resource(url: loadProjectCategoryDetailRequest.url!, modelType: [ProjectCategoryDetail].self)
        let response = try await httpClient.load(loadProjectCategoryDetailResource)
        return response
    }
}
