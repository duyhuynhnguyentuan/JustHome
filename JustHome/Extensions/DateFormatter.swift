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
}
    extension String {
        /// Converts an ISO 8601 date string into a `yyyy-MM-dd HH:mm:ss` format.
        func iso8601ToNormalDateTime() -> String? {
            // First, attempt to convert the string into a Date object using ISO8601DateFormatter
            if let date = DateFormatter.iso8601Formatter.date(from: self) {
                // Use DateFormatter to convert the Date object into the desired format
                return DateFormatter.yyyyMMddHHmmss.string(from: date)
            }
            return nil // Return nil if the string couldn't be parsed into a Date
        }
        func iso8601ToNormalDate() -> String? {
           if let date = DateFormatter.iso8601Formatter.date(from: self) {
                return DateFormatter.yyyyMMdd.string(from: date)
            }
            return nil 
        }
    }
    


