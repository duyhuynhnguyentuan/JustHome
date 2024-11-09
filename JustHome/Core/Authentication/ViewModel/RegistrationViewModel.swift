//
//  RegistrationViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 8/10/24.
//

import Foundation
enum Nationality: String, CaseIterable, Identifiable {
    case vietnam = "Việt Nam 🇻🇳"
    case america = "Mỹ 🇺🇸"
    case japan = "Nhật Bản 🇯🇵"
    case thailand = "Thái Lan 🇹🇭"
    case india = "Ấn Độ 🇮🇳"
    case malaysia = "Malaysia 🇲🇾"
    case korea = "Hàn Quốc 🇰🇷"
    case australia = "Australia 🇦🇺"
    case russia = "Russia 🇷🇺"
    
    var id: Nationality { self }
    
    var nationality: String {
        switch self {
        case .vietnam:
            return "Việt Nam"
        case .america:
            return "Mỹ"
        case .japan:
            return "Nhật Bản"
        case .thailand:
            return "Thái Lan"
        case .india:
            return "Ấn Độ"
        case .malaysia:
            return "Malaysie"
        case .korea:
            return "Hàn Quốc"
        case .australia:
            return "Australia"
        case .russia:
            return "Russia"
        }
    }
}
class RegistrationViewModel: ObservableObject {
    @Published var error: NetworkError?
    @Published var showingOTPSheet: Bool = false
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var fullName = ""
    @Published var nationality: Nationality = .vietnam
    @Published var dateOfBirth = Date()
    @Published var phoneNumber = ""
    @Published var address = ""
    let authService: AuthService
    init(authService: AuthService) {
        self.authService = authService
    }
    @MainActor
    func register() async throws{
        do{
            printUserInputs()
            try await authService.register(body: RegisterBody(
                email: email,
                password: password,
                confirmPass: confirmPassword,
                fullName: fullName,
                dateOfBirth: DateFormatter.yyyyMMdd.string(from: dateOfBirth),
                phoneNumber: "+84\(phoneNumber)",
                identityCardNumber: nil,
                nationality: nationality.nationality,
                placeOfOrigin: nil,
                placeOfResidence: nil,
                dateOfExpiry: nil,
                taxcode: nil,
                bankName: nil,
                bankNumber: nil,
                address: address))
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }

    }
}

// TODO: Delete the below part later, for referencing purpose only
extension RegistrationViewModel {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    func printUserInputs() {
        print("Email: \(email)")
        print("Password: \(password)")
        print("Confirm Password: \(confirmPassword)")
        print("Full Name: \(fullName)")
        print("Nationality: \(nationality.nationality)")
        print("Date of Birth: \(DateFormatter.yyyyMMdd.string(from: dateOfBirth))")
        print("Date of Birth (Formatted): \(DateFormatter.yyyyMMddHHmmss.string(from: dateOfBirth))")
        print("Phone Number: +84\(phoneNumber)")
        print("Address: \(address)")
    }
}
