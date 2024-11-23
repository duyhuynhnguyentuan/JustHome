//
//  StepSixLinearProgressBarView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 22/11/24.
//

import SwiftUI

struct StepSixLinearProgressBarView: View {
    @State private var offset: CGFloat = CGFloat(Constants.COUNTDOWN_TIMER_LENGTH)
    @ObservedObject var stepSixOTPVerificationViewModel: StepSixOTPVerificationViewModel
    init(stepSixOTPVerificationViewModel: StepSixOTPVerificationViewModel){
        self.stepSixOTPVerificationViewModel = stepSixOTPVerificationViewModel
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.5)
                    .foregroundColor(Color.gray)
                
                Rectangle()
                    .frame(width: (CGFloat(offset - CGFloat(stepSixOTPVerificationViewModel.timeRemaining)) * geometry.size.width)/offset, height: geometry.size.height)
                    .foregroundColor(Color.theme.green)
                    .animation(Animation.linear(duration: 1.0), value: offset)
            }.cornerRadius(45.0)
        }
        .frame(height: 5)
    }
}
//
//#Preview {
//    StepSixLinearProgressBarView()
//}
