//
//  PhoneViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import Foundation

class PhoneViewModel: ObservableObject {
      var nowDate = Date()
      let referenceDate = Date(timeIntervalSinceNow:(1 * 5.0))
      @Published var verificationCode = ""
      @Published var verificationID = ""
      @Published var phoneNumber = ""
      @Published var countryCodeNumber = "+84"
      @Published var country = ""
      @Published var code = ""
      @Published var timerExpired = false
      @Published var timeStr = ""
      @Published var timeRemaining = 60
      var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    init(phoneNumber: String){
        self.phoneNumber = phoneNumber
    }
    //MARK: functions
       func startTimer() {
           timerExpired = false
           timeRemaining = Constants.COUNTDOWN_TIMER_LENGTH
           self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
       }
       
       func stopTimer() {
           timerExpired = true
           self.timer.upstream.connect().cancel()
       }

       func countDownString() {
           guard (timeRemaining > 0) else {
               self.timer.upstream.connect().cancel()
               timerExpired = true
               timeStr = String(format: "%02d:%02d", 00,  00)
               return
           }
           
           timeRemaining -= 1
           timeStr = String(format: "%02d:%02d", 00, timeRemaining)
       }
       
    func getPin(at index: Int) -> String {
          guard self.verificationCode.count > index else {
              return ""
          }
        let character = self.verificationCode[self.verificationCode.index(self.verificationCode.startIndex, offsetBy: index)]
        return String(character)
      }
      
      func limitText(_ upper: Int) {
          if verificationCode.count > upper {
              verificationCode = String(verificationCode.prefix(upper))
          }
      }
}
