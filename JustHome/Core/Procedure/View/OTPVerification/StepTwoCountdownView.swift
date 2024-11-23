//
//  StepTwoCountdownVieww.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 20/11/24.
//

import SwiftUI

struct StepTwoCountdownView: View {
    @ObservedObject var stepTwoOTPVerificationViewModel: StepTwoOTPVerificationViewModel
    init(stepTwoOTPVerificationViewModel: StepTwoOTPVerificationViewModel) {
        self.stepTwoOTPVerificationViewModel = stepTwoOTPVerificationViewModel
    }
    var body: some View {
        Text(stepTwoOTPVerificationViewModel.timeStr)
            .font(Font.system(size: 15))
            .foregroundColor(Color.gray)
            .fontWeight(.semibold)
            .onReceive(stepTwoOTPVerificationViewModel.timer) { _ in
                stepTwoOTPVerificationViewModel.countDownString()
            }
    }
}

//#Preview {
//    StepTwoCountdownVieww()
//}
