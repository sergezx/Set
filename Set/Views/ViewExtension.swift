//
//  SwiftUIView.swift
//  Set
//
//  Created by Sergey Zakharenko on 08.01.2023.
//

import SwiftUI

struct RoundButton: ViewModifier {
    private(set) var colorButton: Color = .purple
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorButton, lineWidth: 3)
            )
        
    }
}

extension View {
    func roundButtonStyle(colorButton: Color) -> some View {
        self.modifier(RoundButton(colorButton: colorButton))
    }
}
