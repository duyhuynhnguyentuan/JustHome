//
//  JustHomeTests.swift
//  JustHomeTests
//
//  Created by Huynh Nguyen Tuan Duy on 2/10/24.
//

import Testing
@testable import JustHome
import Foundation

struct JustHomeTests {

    @Test("Get pin function in phone view model")
    func example() async throws {
        let sut = PhoneViewModel(phoneNumber: "083548888")
        sut.verificationCode = "260103"
        let position = sut.getPin(at: 5)
        #expect(position == "3")
    }
    
    @Test("Test date formatter")
    func testDateFormatter() {
        let date = Date()
        #expect(DateFormatter.yyyyMMdd.string(from: date) == "2024-10-09")
    }
    
    @Test("Test ISO 8601 date formatter")
    func testISO8601DateFormatter() {
        let date = Date()

        let ISOdateString = "2024-10-08T12:30:27"
            // Assert the result
            #expect(DateFormatter.iso8601Formatter.string(from: date) == "2024-10-08T12:30:27")
    }
    
    @Test("Parse ISO date format to text")
     func parseISODateFormatToText() {
        let ISOdateString = "2024-10-08T12:30:27"
         if let normalDateTime = ISOdateString.iso8601ToNormalDate(){
             #expect(normalDateTime == "2024-10-08")
         }
    }

}
