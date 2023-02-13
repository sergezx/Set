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
        GeometryReader{ geometry in
            ZStack {
                VStack(alignment: .center) {
                    ForEach (0..<card.content.count.rawValue, id: \.self) {index in
                        cardShape().aspectRatio(DrawingConstants.aspectRatio, contentMode: .fit)
                    }
                    .foregroundColor(colorsShape[card.content.color.rawValue-1])
                }
                .padding()
            }
            .cardify(isFaceUp: card.isFaceUp, isChoosen: card.isChoosen, isHint: card.isHint, isMatched: card.isMatched)
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
        static let lineWidth: CGFloat = 3
        static let aspectRatio: CGFloat = 2/1
    }
}

