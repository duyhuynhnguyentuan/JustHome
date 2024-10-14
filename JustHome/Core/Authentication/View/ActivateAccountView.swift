import SwiftUI

struct ActivateAccountView: View {
    //MARK: vars
    @State var otpCode = ""
    @State private var showPhoneSetupView = false
    @ObservedObject var phoneViewModel: PhoneViewModel
    @Environment(\.dismiss) private var dismiss
    //MARK: init
    init(phoneViewModel: PhoneViewModel) {
        self.phoneViewModel = phoneViewModel
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "barTintColor")
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // Computed property to check if the OTP code is valid
    private var isOtpValid: Bool {
        phoneViewModel.verificationCode.count == Constants.OTP_CODE_LENGTH
    }
    
    // Function to handle OTP verification
    private func verifyOtp() {
        if isOtpValid {
            // Call your authentication method here
            print("OTP is valid, proceeding with authentication.")
            // Example: phoneViewModel.verifyOtp(verificationCode: phoneViewModel.verificationCode)
        } else {
            // Provide feedback to the user if the OTP is not valid
            print("Please enter a valid 6-digit code.")
        }
    }

    //MARK: Body
    var body: some View {
        VStack {
            LinearProgressBarView(phoneViewModel: phoneViewModel)
            
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
                    Text("\(phoneViewModel.countryCodeNumber) \(phoneViewModel.phoneNumber)\(".")")
                        .font(Font.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.primaryText)
                    Text(LocalizedStringKey("Wrong number?"))
                        .font(Font.system(size: 15))
                        .foregroundColor(Color.theme.green)
                }
            }
            .padding(.top, 15)
            
            // OTP Code Digits Input
            VStack {
                Text("6 digit code")
                    .font(Font.system(size: 25))
                    .foregroundColor(Color.gray)
                OtpTextFieldView(phoneViewModel: phoneViewModel)
                    .padding(.leading, 55)
                    .padding(.trailing, 55)
                
                CountDownView(phoneViewModel: phoneViewModel)
                    .padding(.top, 25)
             
                // Reactivate button
                Button {
                    phoneViewModel.startTimer()
                } label: {
                    Text("Resend SMS")
                        .modifier(JHButtonModifier(backgroundColor: phoneViewModel.timerExpired ? Color.theme.green : Color.gray))
                }
                .disabled(!phoneViewModel.timerExpired)
                .padding(15)
                .cornerRadius(50)
                .padding(.top, 35)
            }
            .padding(.top, 35)
            Divider()
                .padding(.horizontal)
            // Button to verify OTP
            Button(action: verifyOtp) {
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
        .navigationBarTitle(LocalizedStringKey("activate.account"), displayMode: .inline)
        .onAppear {
            // Optionally, request verification ID or perform other setup here
            // phoneViewModel.requestVerificationID()
        }
    }
}

#Preview {
    ActivateAccountView(phoneViewModel: PhoneViewModel(phoneNumber: "083028322"))
}
