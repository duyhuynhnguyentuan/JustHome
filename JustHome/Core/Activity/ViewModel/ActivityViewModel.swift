//
//  ActivityViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/10/24.
//

import Foundation


enum BiometricError: Error, LocalizedError, Identifiable {
    var id: UUID { UUID() }

    case deniedAccess
    case noFaceIDEnrolled
    case noFingerprintEnrolled
    case noOpticIdEnrolled
    case biometricError

    var errorDescription: String? {
        switch self {
        case .deniedAccess:
            return "Access denied to biometric authentication. Please allow it in Settings."
        case .noFaceIDEnrolled:
            return "No FaceID enrolled. Please set up FaceID."
        case .noFingerprintEnrolled:
            return "No fingerprints enrolled. Please set up TouchID."
        case .noOpticIdEnrolled:
            return "No OpticID enrolled. Please set up OpticID."
        case .biometricError:
            return "Biometric authentication failed. Please try again."
        }
    }
}

enum BookingsFilter: String, CaseIterable, Codable, Hashable, Identifiable {
    var id: String {rawValue}
    case all = "Tất cả" 
    case chuathanhtoan = "Chưa thanh toán tiền giữ chỗ"
    case dadatcho = "Đã đặt chỗ"
    case dacheckin = "Đã check in"
    case dachonsanpham = "Đã chọn sản phẩm"
    case dakythoathuandatcoc = "Đã ký thỏa thuận đặt cọc"
    case dahuy = "Đã hủy"
}
class ActivityViewModel: ObservableObject {
    @Published var currentBookingsFilter: BookingsFilter = .all
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var error: NetworkError?
    @Published private(set) var bookings = [Bookings]()
    @Published var biometricError: BiometricError?
    let biometricService: BiometricService
    let bookingsService: BookingsService
    let customerID: String
    init(bookingsService: BookingsService, biometricService: BiometricService) {
        self.biometricService = biometricService
        self.bookingsService = bookingsService
        self.customerID =  KeychainService.shared.retrieveToken(forKey: "customerID") ?? ""
        loadData()
    }

    var filteredBookings: [Bookings] {
        if currentBookingsFilter == .all {
            return bookings
        }
        return bookings.filter { $0.status == currentBookingsFilter.rawValue }
    }

    @MainActor
    func loadBookings(by customerID: String) async throws {
        defer { loadingState = .finished }
        do {
            loadingState = .loading
            let bookings = try await bookingsService.loadBooking(by: customerID)
            self.bookings = bookings
        } catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    func authenticateWithBiometrics() throws {
        loadingState = .loading
        biometricService.requestBiometricUnlock { [weak self] result in
            switch result {
            case .success:
                self!.loadingState = .finished
                // Use credentials as needed
            case .failure(let error):
                print("Biometric authentication failed: \(error.localizedDescription)")
                self?.biometricError = error
               
            }
        }
    }
    func loadData() {
        Task(priority: .medium) {
            try await loadBookings(by: customerID)
        }
    }
    
    @MainActor
    func handleRefresh() {
        bookings.removeAll()
        loadData()
    }
}
