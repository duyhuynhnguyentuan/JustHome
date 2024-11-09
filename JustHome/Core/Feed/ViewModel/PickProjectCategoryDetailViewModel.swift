//
//  PickProjectCategoryDetailViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 19/10/24.
//

import Foundation

class PickProjectCategoryDetailViewModel: ObservableObject {
//    @Published var selectedCategory: ProjectCategory?
    @Published var selectedCategoryDetail: ProjectCategoryDetail?
    @Published private(set) var buttonLoadingState: LoadingState = .idle
    @Published private(set) var loadingState: LoadingState = .idle
    @Published private(set) var projectCategoryDetail = [ProjectCategoryDetail]()
    @Published var error: NetworkError?
    @Published var generalError: Error?
    let projectID: String
    let projectCategoryService = ProjectCategoryDetailService(httpClient: HTTPClient())
    let openForSalesService = OpenForSaleService(httpClient: HTTPClient())
    let bookingsService = BookingsService(httpClient: HTTPClient())
    let customerID: String
    init(projectID: String) {
        self.projectID = projectID
        self.customerID =  KeychainService.shared.retrieveToken(forKey: "customerID")!
        loadData(projectID: projectID)
    }
    @MainActor
    func createBooking(categoryDetailID: String, customerID: String) async throws -> CreateBookingResponse {
        defer {
            buttonLoadingState = .finished
        }
        do{
//            let openForSaleID = try await getOpenForSalesId(projectId: projectID)
//            print(openForSaleID)
            buttonLoadingState = .loading
            let response = try await bookingsService.createBooking(categoryDetailID: categoryDetailID, customerID: customerID)
            return response
        }catch let error as NetworkError {
            self.error = error
            throw error
        } catch {
            self.generalError = error
            throw error
        }

    }
    @MainActor
    func getOpenForSalesId(projectId: String) async throws -> String {
        defer {
            buttonLoadingState = .finished
        }
        var openForSales: [OpenForSales]?
        do {
            buttonLoadingState = .loading
            openForSales = try await openForSalesService.loadOpenForSale(projectId: projectId)
        } catch let error as NetworkError {
            self.error = error
            throw error
        } catch {
            self.generalError = error
            throw error
        }
        
        guard let openForSales = openForSales else {
            throw NetworkError.errorResponse(ErrorResponse(message: "cannot find OpenForSales"))
        }
        
        return openForSales.first!.openingForSaleID
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
    //TODO: lấy projectCategoryDetailId xong api get openforsale theo projectCategoryDetailID để sort coi cái nao đang mở bán
    
    func loadData(projectID: String){
        Task(priority: .medium) {
            try await loadProjectCategoryDetail(projectID: projectID)
        }
    }
}
