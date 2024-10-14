//
//  Name.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 11/10/24.
//


import Foundation

extension String {
    /// Returns the initials from the first two words in the string.
    func initialsFromFirstTwoWords() -> String {
        // Split the string into words by spaces
        let nameComponents = self.split(separator: " ")
        
        // Extract the first character of the first two components
        let firstInitial = nameComponents.first?.prefix(1) ?? ""
        let secondInitial = nameComponents.dropFirst().first?.prefix(1) ?? ""
        
        return "\(firstInitial)\(secondInitial)"
    }
}
