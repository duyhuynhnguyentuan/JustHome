//
//  StepTwoOTPVerificationViewModel.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 20/11/24.
//

import Foundation

class StepTwoOTPVerificationViewModel: ObservableObject{
    var nowDate = Date()
    let referenceDate = Date(timeIntervalSinceNow:(1 * 5.0))
    @Published var verificationCode = ""
    @Published var verificationID = ""
    @Published var contractId: String
    @Published var code = ""
    @Published var timerExpired = false
    @Published var timeStr = ""
    @Published var timeRemaining = 90
    @Published var error: NetworkError?
    @Published private(set) var loadingState: LoadingState = .finished
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let contractsService: ContractsService
    init(contractID: String, contractsService: ContractsService){
        self.contractId = contractID
        self.contractsService = contractsService
    }
    //MARK: functions
    func startTimer() async throws {
        try await stepTwoSendOTP()
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
    func stepTwoSendOTP() async throws {
        do {
            _ = try await contractsService.stepTwoSendOTP(by: contractId)
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func stepTwoVerifyOTP() async throws -> MessageResponse {
        defer { loadingState = .finished }
        do {
            loadingState = .loading
            let response = try await contractsService.stepTwoVerifyOTP(by: contractId, otp: verificationCode)
            return response
        }catch let error as NetworkError {
            self.error = error
            print("Error: \(error)")
            throw error
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            throw error
        }
    }
}
