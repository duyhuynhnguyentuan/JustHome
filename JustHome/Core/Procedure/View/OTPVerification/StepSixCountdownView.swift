//
//  StepSixCountdownView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 22/11/24.
//

import SwiftUI

struct StepSixCountdownView: View {
    @ObservedObject var stepSixOTPVerificationViewModel: StepSixOTPVerificationViewModel
    init(stepSixOTPVerificationViewModel: StepSixOTPVerificationViewModel) {
        self.stepSixOTPVerificationViewModel = stepSixOTPVerificationViewModel
    }
    var body: some View {
        Text(stepSixOTPVerificationViewModel.timeStr)
            .font(Font.system(size: 15))
            .foregroundColor(Color.gray)
            .fontWeight(.semibold)
            .onReceive(stepSixOTPVerificationViewModel.timer) { _ in
                stepSixOTPVerificationViewModel.countDownString()
            }
    }
}

//#Preview {
//    StepSixCountdownView()
//}
