//
//  RegistrationView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 8/10/24.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    init(authService: AuthService){
        _viewModel = StateObject(wrappedValue: RegistrationViewModel(authService: authService))
    }
    @Environment(\.properties) var props
    @Environment(\.dismiss) var dismiss
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startComponet = DateComponents(year: 1900, month: 1, day: 1)
        let endComponet =  Date.now
        return calendar.date(from:startComponet)!...endComponet
    }
    var body: some View {
        NavigationStack{
            VStack{
                Image(.justHomeLogo)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: props.isIpad ? 300 : 150, height: props.isIpad ? 300 : 150)
                VStack{
                    TextField("Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(JHTextFieldModifier())
                    SecureField("Mật khẩu", text: $viewModel.password)
                        .autocapitalization(.none)
                        .modifier(JHTextFieldModifier())
                    SecureField("Nhập lại mật khẩu", text: $viewModel.confirmPassword)
                        .autocapitalization(.none)
                        .modifier(JHTextFieldModifier())
                    TextField("Tên đầy đủ",text:$viewModel.fullName)
                        .autocapitalization(.words)
                        .modifier(JHTextFieldModifier())
                    DatePicker(selection: $viewModel.dateOfBirth,in: dateRange, displayedComponents: .date){
                    Text("Ngày sinh")
                        Text("Chọn ngày sinh")
                    }
                    .datePickerStyle(.compact)
                    .modifier(JHTextFieldModifier())
                    Picker("Quốc tịch", selection: $viewModel.nationality){
                        ForEach(Nationality.allCases){nat in
                            Text(nat.rawValue).tag(nat)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .modifier(JHTextFieldModifier())
                    HStack {
                        Text("+84")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        Divider()
                            .frame(height: 30)
                            .padding(.horizontal, 8)

                        TextField("Số điện thoại", text: $viewModel.phoneNumber)
                            .keyboardType(.phonePad)

                    } .modifier(JHTextFieldModifier())
                    TextField("Địa chỉ",text:$viewModel.address)
                        .autocapitalization(.words)
                        .modifier(JHTextFieldModifier())
                    
                }
                Button {
                    viewModel.showingOTPSheet.toggle()
                } label: {
                    Text("Đăng kí")
                        .modifier(JHButtonModifier())
                }
                .padding(.vertical)
                // MARK: bottom part
                Spacer()
                Divider()
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Đã có tài khoản?")
                        
                        Text("Đăng nhập")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color.theme.primaryText)
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
            .sheet(isPresented: $viewModel.showingOTPSheet) {
                ActivateAccountView(phoneViewModel: PhoneViewModel(email: viewModel.email, OTPService: OTPService(httpClient: HTTPClient()), registrationViewModel: viewModel))
                    .interactiveDismissDisabled()
                
            }
            .alert(item: $viewModel.error) { error in
                // Handle alert cases
                switch error {
                case .badRequest:
                    return Alert(
                        title: Text("Bad Request"),
                        message: Text("Unable to perform the request."),
                        dismissButton: .default(Text("OK"))
                    )
                case .decodingError(let decodingError):
                    return Alert(
                        title: Text("Decoding Error"),
                        message: Text(decodingError.localizedDescription),
                        dismissButton: .default(Text("OK"))
                    )
                case .invalidResponse:
                    return Alert(
                        title: Text("Invalid Response"),
                        message: Text("The server response was invalid."),
                        dismissButton: .default(Text("OK"))
                    )
                case .errorResponse(let errorResponse):
                    return Alert(
                        title: Text("Lỗi"),
                        message: Text(errorResponse.message ?? "An unknown error occurred."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}

#Preview {
    RegistrationView(authService: AuthService(keychainService: KeychainService.shared, httpClient: HTTPClient()))
}
