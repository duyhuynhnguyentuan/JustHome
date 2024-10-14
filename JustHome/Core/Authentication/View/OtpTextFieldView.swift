//
//  OtpTextFieldView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import SwiftUI
import Combine

struct OtpTextFieldView: View {
    enum FocusField: Hashable {
        case field
    }
    @ObservedObject var phoneViewModel: PhoneViewModel
    @FocusState private var focusedField: FocusField?
    
    init(phoneViewModel: PhoneViewModel){
        self.phoneViewModel = phoneViewModel
        UITextField.appearance().clearButtonMode = .never
        UITextField.appearance().tintColor = UIColor.clear
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            TextField("", text: $phoneViewModel.verificationCode)
                .frame(width: 0, height: 0, alignment: .center)
                .font(Font.system(size: 0))
                .accentColor(.blue)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .onReceive(Just(phoneViewModel.verificationCode)) { _ in phoneViewModel.limitText(Constants.OTP_CODE_LENGTH) }
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
                        Text(phoneViewModel.getPin(at: index ))
                            .font(Font.system(size: 27))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.green)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color.theme.primaryText)
                            .padding(.trailing, 5)
                            .padding(.leading, 5)
                            .opacity(phoneViewModel.verificationCode.count <= index ? 1 : 0)
                    }
                }
            }
        }
    }
}
#Preview {
    OtpTextFieldView(phoneViewModel: PhoneViewModel(phoneNumber: "0808008"))
}
