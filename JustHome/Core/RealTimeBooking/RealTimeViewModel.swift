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
    @Published var runningOutOfTime: Bool = false
    @Published var timeRemaining: Int = 0
      @Published var isTimerRunning: Bool = false
      private var timer: Timer?
    @Published var selectedProperty: Property?
    @Published private(set) var properties = [Property]()
    @Published private(set) var depositedBooking: Bookings?
    @Published var currentFilter: PropertyFilter = .all
    // Picker selections
    @Published var selectedZoneName: String = ""
    @Published var selectedBlockName: String = ""
    @Published var selectedNumFloor: Int? = nil
    @Published private(set) var loadingState: LoadingState = .idle
    @EnvironmentObject private var routerManager : NavigationRouter
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
    var isCurrentUserDeposited: Bool {
        depositedBooking?.customerID == customerID
    }
    func handleDepositedStatus() {
        if isCurrentUserDeposited {
            startTimer()
        } else {
            stopTimer()
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
    func startTimer(for duration: Int = 120) {
        timeRemaining = duration
        isTimerRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                Task {
                    try await self.deleteBooking(bookingID: self.depositedBooking?.bookingID ?? "")
                }
                runningOutOfTime = true
            }
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
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
    //its actually not choosing booking 
    @MainActor
    func deleteBooking(bookingID: String) async throws{
        do{
            let message = try await propertyService.deleteBooking(bookingID: bookingID)
            print(message)
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
            handleDepositedStatus()
        }catch let error as NetworkError{
            self.error = error
            print(error.localizedDescription)
        }catch{
            print("Other error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func selectProperty(by propertyId: String) async throws -> MessageResponse? {
        defer{
            loadingState = .finished
        }
        do{
            loadingState = .loading
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
