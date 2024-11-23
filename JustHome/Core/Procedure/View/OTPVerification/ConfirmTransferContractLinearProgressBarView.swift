//
//  ConfirmTransferContractLinearProgressBarView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import SwiftUI

struct ConfirmTransferContractLinearProgressBarView: View {
    @State private var offset: CGFloat = CGFloat(Constants.COUNTDOWN_TIMER_LENGTH)
    @ObservedObject var confirmTransferContractOTPVerificationViewModel: ConfirmTransferContractOTPVerificationViewModel
    init(confirmTransferContractOTPVerificationViewModel: ConfirmTransferContractOTPVerificationViewModel){
        self.confirmTransferContractOTPVerificationViewModel = confirmTransferContractOTPVerificationViewModel
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.5)
                    .foregroundColor(Color.gray)
                
                Rectangle()
                    .frame(width: (CGFloat(offset - CGFloat(confirmTransferContractOTPVerificationViewModel.timeRemaining)) * geometry.size.width)/offset, height: geometry.size.height)
                    .foregroundColor(Color.theme.green)
                    .animation(Animation.linear(duration: 1.0), value: offset)
            }.cornerRadius(45.0)
        }
        .frame(height: 5)
    }
}

//#Preview {
//    ConfirmTransferContractLinearProgressBarView()
//}
