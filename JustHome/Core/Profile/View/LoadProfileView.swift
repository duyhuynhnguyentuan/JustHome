//
//  LoadProfileView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 26/11/24.
//

import SwiftUI

struct LoadProfileView: View {
    @StateObject var viewModel: LoadProfileViewModel
    var customer: loadCustomerByIDResponse
    @State private var updatedFullName: String
    @State private var updatedDateOfBirth: Date
    @State private var updatedPhoneNumber: String
    @State private var updatedNationality: Nationality
    @State private var updatedAddress: String
    @EnvironmentObject private var routerManager: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startComponet = DateComponents(year: 1900, month: 1, day: 1)
        let endComponet =  Date.now
        return calendar.date(from:startComponet)!...endComponet
    }
    // Create an initializer that allows passing the customer data
    // LoadProfileView.swift
    init(customer: loadCustomerByIDResponse) {
        self.customer = customer
        _updatedFullName = State(initialValue: customer.fullName)
        _updatedDateOfBirth = State(initialValue: DateFormatter.yyyyMMdd.date(from: customer.dateOfBirth) ?? Date())
        _updatedPhoneNumber = State(initialValue: customer.phoneNumber)
        _updatedNationality = State(initialValue: Nationality(rawValue: customer.nationality) ?? .vietnam)
        _updatedAddress = State(initialValue: customer.address)
        _viewModel = StateObject(wrappedValue: LoadProfileViewModel(customerService: CustomerService(httpClient: HTTPClient())))
    }


    var body: some View {
        //TODO: Thành công thì show message :v
        VStack(spacing: 20) {
            Text("Chỉnh sửa thông tin cá nhân")
                .font(.title)
                .bold()

            // Full Name
            TextField("Tên đầy đủ", text: $updatedFullName)
                .autocapitalization(.words)
                .modifier(JHTextFieldModifier())

            // Date of Birth
            DatePicker("Ngày sinh", selection: $updatedDateOfBirth, in: dateRange, displayedComponents: .date)
                .datePickerStyle(.compact)
                .modifier(JHTextFieldModifier())

            // Phone Number
            HStack {
                Text("+84")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)

                Divider()
                    .frame(height: 30)
                    .padding(.horizontal, 8)

                TextField("Số điện thoại", text: $updatedPhoneNumber)
                    .keyboardType(.phonePad)
            }
            .modifier(JHTextFieldModifier())

            // Nationality Picker
            Text("Quốc tịch hiện tại: \(customer.nationality)")
            Picker("Quốc tịch", selection: $updatedNationality) {
                ForEach(Nationality.allCases) { nat in
                    Text(nat.rawValue).tag(nat)
                }
            }
            .pickerStyle(.navigationLink)
            .modifier(JHTextFieldModifier())

            // Address
            TextField("Địa chỉ", text: $updatedAddress)
                .autocapitalization(.words)
                .modifier(JHTextFieldModifier())

            // Confirm Button
            Button{
                // Handle the save logic here, you can pass the updated values back to the profile view model or handle it within this view
                Task{
                    try await viewModel.updateProfile(fullName: updatedFullName, dateOfBirth: DateFormatter.yyyyMMdd.string(from: updatedDateOfBirth), phoneNumber: updatedPhoneNumber, nationality: updatedNationality.nationality, address: updatedAddress)
                    dismiss()
                }
                // Call save function or update API request here
            }label: {
                Text("Xác nhận")
                    .modifier(JHButtonModifier())
            }

        }
        .padding()
    }
}

//#Preview {
//    LoadProfileView(customer: .constant(loadCustomerByIDResponse(customerID: "12345", fullName: "John Doe", dateOfBirth: "2000-01-01", phoneNumber: "123456789", nationality: "Việt Nam", address: "1234 Example St")))
//}

