//
//  JHButtonModifier.swift
//  JustHome
//
//  Created by Huynh Nguyen Tuan Duy on 5/10/24.
//

import SwiftUI

struct JHButtonModifier: ViewModifier {
    let buttonHeight: CGFloat
    let backgroundColor: Color
    let buttonWidht: CGFloat
    
    init(buttonHeight: CGFloat = 44, backgroundColor: Color = .theme.green, buttonWidth: CGFloat = 352) {
        self.buttonHeight = buttonHeight
        self.backgroundColor = backgroundColor
        self.buttonWidht = buttonWidth
    }
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: buttonWidht, height: buttonHeight)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

struct ButtonWithBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 352, height: 32)
            .background(.white)
            .cornerRadius(8)
    }
}
