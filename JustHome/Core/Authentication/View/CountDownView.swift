//
//  CountDownView.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import SwiftUI

struct CountDownView: View {
    
    @ObservedObject var phoneViewModel: PhoneViewModel
    
    init(phoneViewModel: PhoneViewModel){
        self.phoneViewModel = phoneViewModel
    }
    
    var body: some View {
        Text(phoneViewModel.timeStr)
            .font(Font.system(size: 15))
            .foregroundColor(Color.gray)
            .fontWeight(.semibold)
            .onReceive(phoneViewModel.timer) { _ in
                phoneViewModel.countDownString()
            }
    }
}

#Preview {
    CountDownView(phoneViewModel: PhoneViewModel(phoneNumber: "0835488888"))
}
