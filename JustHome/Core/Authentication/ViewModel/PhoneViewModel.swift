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
      @Published var email = ""
      @Published var code = ""
      @Published var timerExpired = false
      @Published var timeStr = ""
      @Published var timeRemaining = 90
      @Published var error: NetworkError?
      @Published private(set) var loadingState: LoadingState = .finished
     let registrationViewModel: RegistrationViewModel
      var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let OTPService: OTPService
    init(email: String, OTPService: OTPService, registrationViewModel: RegistrationViewModel){
        self.email = email
        self.OTPService = OTPService
        self.registrationViewModel = registrationViewModel
    }
    //MARK: functions
    func startTimer() async throws {
        try await sendEmail()
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
    @MainActor
    func sendEmail() async throws{
        do{
            _ = try await OTPService.sendEmail(email: email)
        }
        catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func verifyOTP(email: String, otp: String) async throws {
        defer { loadingState = .finished }
        do{
            loadingState = .loading
            let response = try await OTPService.verifyOTP(email: email, otp: otp)
            if (response.message != nil) {
                try await registrationViewModel.register()
            }
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
}

