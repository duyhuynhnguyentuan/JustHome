//
//  PanoramaImageService.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/11/24.
//

import Foundation

protocol PanoramaImageServiceProtocol {
    func loadPanoramaImage(projectID: String) async throws -> [PanoramaImage]
}

class PanoramaImageService: PanoramaImageServiceProtocol {
    let httpClient: HTTPClient
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func loadPanoramaImage(projectID: String) async throws -> [PanoramaImage] {
        let loadPanoramaImageRequest = JHRequest(endpoint: .PanoramaImage, pathComponents: ["getpanoramabyprojectid", projectID])
        let loadPanoramaImageResource = Resource(url: loadPanoramaImageRequest.url!, modelType: [PanoramaImage].self)
        let loadPanoramaImageResponse = try await httpClient.load( loadPanoramaImageResource)
        return loadPanoramaImageResponse
    }
    
    
}
