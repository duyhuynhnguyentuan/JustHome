//
//  StepSixOTPTextFieldView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 22/11/24.
//

import SwiftUI
import Combine

struct StepSixOTPTextFieldView: View {
    enum FocusField: Hashable {
        case field
    }
    @ObservedObject var stepSixOTPVerificationViewModel: StepSixOTPVerificationViewModel
    @FocusState private var focusedField: FocusField?
    init(stepSixOTPVerificationViewModel: StepSixOTPVerificationViewModel){
        self.stepSixOTPVerificationViewModel = stepSixOTPVerificationViewModel
        UITextField.appearance().clearButtonMode = .never
        UITextField.appearance().tintColor = UIColor.clear
    }
    var body: some View {
        ZStack(alignment: .center) {
            TextField("", text: $stepSixOTPVerificationViewModel.verificationCode)
                .frame(width: 0, height: 0, alignment: .center)
                .font(Font.system(size: 0))
                .accentColor(.blue)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .onReceive(Just(stepSixOTPVerificationViewModel.verificationCode)) { _ in stepSixOTPVerificationViewModel.limitText(Constants.OTP_CODE_LENGTH) }
                .focused($focusedField, equals: .field)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                    {
                        self.focusedField = .field
                    }
                }
                .padding()
            //not the text field
            HStack {
                ForEach(0..<Constants.OTP_CODE_LENGTH, id: \.self) { index in
                    ZStack {
                        Text(stepSixOTPVerificationViewModel.getPin(at: index ))
                            .font(Font.system(size: 27))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.green)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color.theme.primaryText)
                            .padding(.trailing, 5)
                            .padding(.leading, 5)
                            .opacity(stepSixOTPVerificationViewModel.verificationCode.count <= index ? 1 : 0)
                    }
                }
            }
        }

    }
}

//#Preview {
//    StepSixOTPTextFieldView()
//}
