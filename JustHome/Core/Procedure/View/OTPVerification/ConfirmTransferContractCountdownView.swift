//
//  ConfirmTransferContractCountdownView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 23/11/24.
//

import SwiftUI

struct ConfirmTransferContractCountdownView: View {
    @ObservedObject var confirmTransferContractOTPVerificationViewModel: ConfirmTransferContractOTPVerificationViewModel
    init(confirmTransferContractOTPVerificationViewModel: ConfirmTransferContractOTPVerificationViewModel) {
        self.confirmTransferContractOTPVerificationViewModel = confirmTransferContractOTPVerificationViewModel
    }
    var body: some View {
        Text(confirmTransferContractOTPVerificationViewModel.timeStr)
            .font(Font.system(size: 15))
            .foregroundColor(Color.gray)
            .fontWeight(.semibold)
            .onReceive(confirmTransferContractOTPVerificationViewModel.timer) { _ in
                confirmTransferContractOTPVerificationViewModel.countDownString()
            }
    }
}

//#Preview {
//    ConfirmTransferContractCountdownView()
//}
