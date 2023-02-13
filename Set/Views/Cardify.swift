//
//  Cardify.swift
//  Set
//
//  Created by Sergey Zakharenko on 18.01.2023.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    var isChoosen: Bool
    var isHint: Bool
    var isMatched: Bool?
    
    init (isFaceUp: Bool, isChoosen: Bool, isHint: Bool, isMatched: Bool?) {
        rotation = isFaceUp ? 0 : 180
        self.isChoosen = isChoosen
        self.isHint = isHint
        self.isMatched = isMatched
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double // in degrees

    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)

//            if isFaceUp {
//                shape.fill().foregroundColor(.white)
//            } else {
//                shape.fill()
//            }

            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                
                if isChoosen {
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth+2).foregroundColor(.gray)
                } else {
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                }

                if isHint {
                    shape.foregroundColor(DrawingConstants.colorOfHint).opacity(0.3)
                }
                if let isMatched = isMatched {
                    Group{
                        if isMatched {
                            shape.foregroundColor(DrawingConstants.colorMatchedCard)
                        }
                        else {
                            shape.foregroundColor(DrawingConstants.colorUnmatchedCard)
                        }
                    }
                    .opacity(0.5)
                }
            }
            else {
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0 )
//            content.opacity(isFaceUp ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0)  )
        .rotationEffect(Angle.degrees(isMatched ==  true ? 360 : 0))
        .rotationEffect(Angle.degrees(isMatched == false ? 3 : 0))

    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let colorMatchedCard : Color = .green
        static let colorUnmatchedCard : Color = .red
        static let colorOfHint : Color = .blue

    }
}

extension View {
    func cardify(isFaceUp: Bool, isChoosen: Bool, isHint: Bool, isMatched: Bool?) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp, isChoosen: isChoosen, isHint: isHint, isMatched: isMatched ?? nil))
    }
}
