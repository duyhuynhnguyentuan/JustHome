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
    @Published var error: NetworkError?
    @Published var generalError: Error?
    let projectID: String
    let projectCategoryService = ProjectCategoryDetailService(httpClient: HTTPClient())
    init(projectID: String){
        self.projectID = projectID
        loadData(projectID: projectID)
    }
    var hasOpenForSale: Bool {
        projectCategoryDetail.contains { $0.openForSale }
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
        }
    }

}
