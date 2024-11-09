//
//  ProjectService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 15/10/24.
//

import Foundation

protocol ProjectsServiceProtocol {
    func loadProjects(projectName: String?, page: Int?) async throws -> ProjectResponse
    func loadProject(withId id: String) async throws -> Project
}

class ProjectsService: ProjectsServiceProtocol {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    @MainActor
    func loadProjects(projectName: String? = nil, page: Int? = nil) async throws -> ProjectResponse {
        var queryItems: [URLQueryItem] = []
        
        // Add project name query if provided
        if let projectName = projectName {
            queryItems.append(URLQueryItem(name: "projectName", value: projectName))
        }
        
        // Add page query if provided
        if let page = page {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        
        // Construct the request
        let loadProjectsRequest = JHRequest(endpoint: .projects, queryParameters: queryItems)
        
        // Define the resource
        let loadProjectsResource = Resource(url: loadProjectsRequest.url!, method: .get, modelType: ProjectResponse.self)
        
        // Perform the network request
        let resultProjects = try await httpClient.load(loadProjectsResource)
        return resultProjects
    }
    
    @MainActor
    func loadProject(withId id: String) async throws -> Project {
        let loadProjectRequest = JHRequest(endpoint: .projects, pathComponents: [id])
        let loadProjectResource = Resource(url: loadProjectRequest.url!, method: .get, modelType: Project.self)
        let resultProject = try await httpClient.load(loadProjectResource)
        return resultProject
    }
}
