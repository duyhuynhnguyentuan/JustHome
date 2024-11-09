//
//  RealTimeViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 8/11/24.
//

import Foundation
import SwiftUI
import SignalRClient

enum PropertyFilter: String, CaseIterable, Codable, Hashable, Identifiable {
    var id: String {rawValue}
    case all = "Tất cả"
    case moban = "Mở bán"
    case giucho = "Giữ chỗ"
    var color: Color {
        switch self {
        case .all:
                .systemGray2
        case .moban:
                .cyan
        case .giucho:
                .red
        }
    }
}
class RealTimeViewModel: ObservableObject {
    @Published var error: NetworkError?
    let propertyService: PropertyService
    let categoryDetailID: String
    let customerID: String
    @Published var selectedProperty: Property?
    @Published private(set) var properties = [Property]()
    @Published private(set) var depositedBooking: Bookings?
    @Published var currentFilter: PropertyFilter = .all
    // Picker selections
    @Published var selectedZoneName: String = ""
    @Published var selectedBlockName: String = ""
    @Published var selectedNumFloor: Int? = nil
    private var hubConnection: HubConnection?
    var filteredProperties: [Property] {
        properties.filter { property in
            // Apply status filter
            (currentFilter == .all || property.status == currentFilter.rawValue) &&
            // Apply zone filter
            (selectedZoneName.isEmpty || property.zoneName == selectedZoneName) &&
            // Apply block filter
            (selectedBlockName.isEmpty || property.blockName == selectedBlockName) &&
            // Apply floor filter
            (selectedNumFloor == nil || property.numFloor == selectedNumFloor)
        }
    }
    var propertyStatusCounts: [PropertyFilter: Int] {
        var counts = [PropertyFilter: Int]()
        
        for filter in PropertyFilter.allCases {
            counts[filter] = properties.filter { property in
                filter == .all || property.status == filter.rawValue
            }.count
        }
        
        return counts
    }
    func setupSignalRConnection() {
        // Replace with your actual backend URL
        hubConnection = HubConnectionBuilder(url: URL(string: "wss://realestateproject-bdhcgphcfsf6b4g2.canadacentral-01.azurewebsites.net/propertyHub")!)
            .withLogging(minLogLevel: .debug)
            .withAutoReconnect()
            .build()
        
        hubConnection?.on(method: "ReceivePropertyStatus") { [weak self] (propertyId: String, status: String) in
            //refresh data
            self!.handleRefresh()
            print("\(propertyId) được chọn với status \(status)")
        }
        
        hubConnection?.start()
    }
    func disconnect() {
        hubConnection?.stop()
    }
    //MARK: - Initializer
    init(PropertyService: PropertyService, categoryDetailID: String) {
        self.customerID =  KeychainService.shared.retrieveToken(forKey: "customerID") ?? "N/A"
        self.propertyService = PropertyService
        self.categoryDetailID = categoryDetailID
        loadData()
        setupSignalRConnection()
    }
    deinit {
          disconnect()
      }
    //MARK: - Main functionalities
    @MainActor
    func getProperties(by categoryDetailID: String) async throws {
        do{
            let propertys = try await propertyService.getProperty(by: categoryDetailID)
            self.properties = propertys
        }catch let error as NetworkError{
            self.error = error
            print(error.localizedDescription)
        }catch{
            print("Other error: \(error.localizedDescription)")
        }
    }

    @MainActor
    func getBookingDeposits(by projectCategortDetailId: String) async throws {
        do {
            let depositedBooking = try await propertyService.getBookingDeposits(by: projectCategortDetailId)
            self.depositedBooking = depositedBooking
        }catch let error as NetworkError{
            self.error = error
            print(error.localizedDescription)
        }catch{
            print("Other error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func selectProperty(by propertyId: String) async throws -> MessageResponse? {
        do{
          let response = try await propertyService.selectProperty(by: propertyId, by: customerID)
            return response
        }catch let error as NetworkError{
            self.error = error
            print(error.localizedDescription)
            return nil
        }catch{
            print("Other error: \(error.localizedDescription)")
            return nil
        }
    }

    func handleRefresh(){
        loadData()
    }
    func loadData(){
        Task(priority: .medium){
            try await getProperties(by: categoryDetailID)
            try await getBookingDeposits(by: categoryDetailID)
        }
    }
}