//
//  DateFormatter.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 9/10/24.
//

import Foundation

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let yyyyMMddHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    static let iso8601WithFractionalSecondsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
extension String {
    func iso8601ToNormalDateTime() -> String? {
        if let date = DateFormatter.iso8601WithFractionalSecondsFormatter.date(from: self) {
            return DateFormatter.yyyyMMddHHmmss.string(from: date)
        }
        return nil
    }

    func iso8601ToNormalDate() -> String? {
        if let date = DateFormatter.iso8601WithFractionalSecondsFormatter.date(from: self) {
            return DateFormatter.yyyyMMdd.string(from: date)
        }
        return nil
    }
}
    


