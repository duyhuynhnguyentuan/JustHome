//
//  ProjectDetailViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 18/10/24.
//

import Foundation

class ProjectDetailViewModel: ObservableObject {
    @Published var showImageViewer = false
    @Published var selectedImageID: String = ""
    @Published private(set) var loadingState: LoadingState = .idle
    @Published private(set) var projectCategoryDetail = [ProjectCategoryDetail]()
    @Published private(set) var panoramaImages = [PanoramaImage]()
    @Published var error: NetworkError?
    @Published var generalError: Error?
    @Published private(set) var salesPolicy = [SalesPolicy]()
    let projectID: String
    let policyService = SalespoliciesService(httpClient: HTTPClient())
    let projectCategoryService = ProjectCategoryDetailService(httpClient: HTTPClient())
    let panoramaImageService = PanoramaImageService(httpClient: HTTPClient())
    init(projectID: String){
        self.projectID = projectID
        loadData(projectID: projectID)
    }
    var hasOpenForSale: Bool {
        projectCategoryDetail.contains {
            $0.openForSale == "Giữ chỗ" || $0.openForSale == "Mua trực tiếp"
        }
    }
    var listOfProejctCategoryDetailName: [String] {
         projectCategoryDetail.map { $0.propertyCategoryName }
     }
    @MainActor
    func loadPanoramaImages(projectID: String) async throws {
        defer {
            loadingState = .finished
        }
        do{
            loadingState = .loading
            let panoramaImages = try await panoramaImageService.loadPanoramaImage(projectID: projectID)
            self.panoramaImages = panoramaImages
        }catch let error as NetworkError {
            self.error = error
        }
    }
    @MainActor
    func loadSalesPolicy(projectID: String) async throws{
        defer {
            loadingState = .finished
        }
        do{
            loadingState = .loading
            let salesPolicy = try await policyService.loadSalesPolicys(projectID: projectID)
            self.salesPolicy = salesPolicy
        }catch let error as NetworkError {
            self.error = error
        }
    }
    @MainActor
    func loadProjectCategoryDetail(projectID: String) async throws{
        defer {
            loadingState = .finished
        }
        do{
            loadingState = .loading
            let projectCategoryDetail = try await projectCategoryService.loadProjectCategoryDetail(projectID: projectID)
            self.projectCategoryDetail = projectCategoryDetail
        }catch let error as NetworkError {
            self.error = error
        }catch {
            self.generalError = error
        }
    }
    func loadData(projectID: String){
        Task(priority: .medium) {
            try await loadProjectCategoryDetail(projectID: projectID)
            try await loadSalesPolicy(projectID: projectID)
            try await loadPanoramaImages(projectID: projectID)
        }
    }

}
