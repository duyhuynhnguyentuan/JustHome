//
//  StepTwoLinearProgressBarView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 20/11/24.
//

import SwiftUI

struct StepTwoLinearProgressBarView: View {
    @State private var offset: CGFloat = CGFloat(Constants.COUNTDOWN_TIMER_LENGTH)
    @ObservedObject var stepTwoOTPVerificationViewModel: StepTwoOTPVerificationViewModel
    init(stepTwoOTPVerificationViewModel: StepTwoOTPVerificationViewModel){
        self.stepTwoOTPVerificationViewModel = stepTwoOTPVerificationViewModel
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.5)
                    .foregroundColor(Color.gray)
                
                Rectangle()
                    .frame(width: (CGFloat(offset - CGFloat(stepTwoOTPVerificationViewModel.timeRemaining)) * geometry.size.width)/offset, height: geometry.size.height)
                    .foregroundColor(Color.theme.green)
                    .animation(Animation.linear(duration: 1.0), value: offset)
            }.cornerRadius(45.0)
        }
        .frame(height: 5)
    }
}

//#Preview {
//    StepTwoLinearProgressBarView()
//}
