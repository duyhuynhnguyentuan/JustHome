//
//  ConfirmTransferContractOTPVerification.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import SwiftUI

struct ConfirmTransferContractOTPVerification: View {
    @State var otpCode = ""
    @StateObject var confirmTransferContractOTPVerificationViewModel: ConfirmTransferContractOTPVerificationViewModel
    @EnvironmentObject private var routerManager: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    let contractID: String
    init(contractID: String){
        self.contractID = contractID
        _confirmTransferContractOTPVerificationViewModel = StateObject(wrappedValue: ConfirmTransferContractOTPVerificationViewModel(contractID: contractID, contractsService: ContractsService(httpClient: HTTPClient())))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "barTintColor")
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    // Computed property to check if the OTP code is valid
    private var isOtpValid: Bool {
        confirmTransferContractOTPVerificationViewModel.verificationCode.count == Constants.OTP_CODE_LENGTH
    }
    // Function to handle OTP verification
    private func verifyOtp() async throws {
        if isOtpValid {
            // Call your authentication method here
            let response = try await confirmTransferContractOTPVerificationViewModel.confirmContractVerifyOTP()
            if(response.message != nil){
                routerManager.push(to: .procedure)
                routerManager.reset()
            }
            print("OTP is valid, proceeding with authentication.")
            // Example: phoneViewModel.verifyOtp(verificationCode: phoneViewModel.verificationCode)
        } else {
            // Provide feedback to the user if the OTP is not valid
            print("Please enter a valid 6-digit code.")
        }
    }
    var body: some View {
        VStack{
            switch confirmTransferContractOTPVerificationViewModel.loadingState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
            case .finished:
                VStack {
                    ConfirmTransferContractLinearProgressBarView(confirmTransferContractOTPVerificationViewModel: confirmTransferContractOTPVerificationViewModel)
                    
                    // Phone number description
                    VStack(spacing: 0) {
                        Button{
                            dismiss()
                        }label: {
                            Text("Hủy xác nhận SMS")
                                .font(Font.system(size: 15))
                                .underline()
                                .foregroundColor(Color.red)
                        }
                        .padding(.bottom)
                        HStack(spacing: 1) {
                            Text("Đã gửi mã đến email của bạn")
                                .font(Font.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.theme.primaryText)
                            //                    Text(LocalizedStringKey("Wrong number?"))
                            //                        .font(Font.system(size: 15))
                            //                        .foregroundColor(Color.theme.green)
                        }
                    }
                    .padding(.top, 15)
                    
                    // OTP Code Digits Input
                    VStack {
                        Text("6 digit code")
                            .font(Font.system(size: 25))
                            .foregroundColor(Color.gray)
                        ConfirmTransferContractOtpTextFieldView(confirmTransferContractOTPVerificationViewModel: confirmTransferContractOTPVerificationViewModel)
                            .padding(.leading, 55)
                            .padding(.trailing, 55)
                        
                        ConfirmTransferContractCountdownView(confirmTransferContractOTPVerificationViewModel: confirmTransferContractOTPVerificationViewModel)
                            .padding(.top, 25)
                        
                        // Reactivate button
                        Button {
                            Task{
                                try await confirmTransferContractOTPVerificationViewModel.startTimer()
                            }
                        } label: {
                            Text("Resend OTP")
                                .modifier(JHButtonModifier(backgroundColor: confirmTransferContractOTPVerificationViewModel.timerExpired ? Color.theme.green : Color.gray))
                        }
                        .disabled(!confirmTransferContractOTPVerificationViewModel.timerExpired)
                        .padding(15)
                        .cornerRadius(50)
                        .padding(.top, 35)
                    }
                    .padding(.top, 35)
                    Divider()
                        .padding(.horizontal)
                    // Button to verify OTP
                    Button {
                        Task{
                            try await verifyOtp()
                        }
                    } label: {
                        Text("Verify OTP")
                            .fontWeight(.bold)
                            .padding()
                            .background(isOtpValid ? Color.theme.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!isOtpValid)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle(LocalizedStringKey("Xác thực OTP của TTDC"), displayMode: .inline)
                .alert(item: $confirmTransferContractOTPVerificationViewModel.error) { error in
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
        .onAppear {
            Task{
                try await confirmTransferContractOTPVerificationViewModel.confirmContractSendOTP()
            }
        }
    }
}

//#Preview {
//    ConfirmTransferContractOTPVerification()
//}
