//
//  SetCardView.swift
//  SetV2
//
//  Created by Sergey on 13.12.2022.
//

import SwiftUI


struct CardView: View {
    var card: SetCardGame.Card
    var colorsShape: [Color] = [.red, .green, .purple]
    
    var body: some View {
        GeometryReader{geometry in
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            shape.fill().foregroundColor(.white)
            if card.isChoosen {
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth+2).foregroundColor(.gray)
            } else {
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }
            
// вынести в функцию, действия однотипны, наклаыдваем лишь фон
            if card.isHint {
                shape.foregroundColor(.blue).opacity(0.3)
            }
            if let isMatched = card.isMatched {
                if isMatched {
                    shape.foregroundColor(.green).opacity(0.5)
                }
                else {
                    shape.foregroundColor(.red).opacity(0.5)
                }
            }
            
            VStack {
                Spacer()
                ForEach (0..<card.content.count.rawValue, id: \.self) {index in
                    cardShape().aspectRatio(2/1, contentMode: .fit)
                }
                .foregroundColor(colorsShape[card.content.color.rawValue-1])
                Spacer()
            }
            .padding()
        }
    }
    
    private func cardShape() -> some View {
        ZStack{
            switch card.content.shape {
            case .v1:  shapeFill(shape: Squiggle())
            case .v2:  shapeFill(shape: Diamond())
            case .v3:  shapeFill(shape: Capsule())
            }
        }
    }
    
    private func shapeFill<SetShape>(shape: SetShape) -> some View where SetShape: Shape {
        ZStack {
            switch card.content.fill {
            case .v1: shape.stroke(lineWidth: DrawingConstants.lineWidth)
            case .v2: shape.fillAndBorder(DrawingConstants.lineWidth)
            case .v3: shape.stripe(DrawingConstants.lineWidth)
            }
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

