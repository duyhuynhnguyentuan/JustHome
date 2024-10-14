//
//  JHTextFieldModifier.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 5/10/24.
//


import SwiftUI

struct JHTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
