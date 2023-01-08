//
//  Squiggle.swift
//  Set
//
//  Created by Sergey on 07.12.2022.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var upper = Path()
        let start = CGPoint (x: rect.minX, y: rect.midY)
        let sqbx = rect.width * 0.1
        let sqby = rect.height * 0.2

        upper.move(to: start)
        upper.addCurve(
            to: CGPoint(x: rect.minX + rect.width * 1/2, /* rect.maxX/2 */
                        y: rect.minY + rect.height / 8), /* rect.maxY/8 */
            control1: CGPoint(x: rect.minX, y: rect.minY),
            control2: CGPoint(x: rect.minX + rect.width * 1/2 - sqbx,
                              y: rect.minY + rect.height / 8 - sqby)
        )
        upper.addCurve(
            to: CGPoint(x: rect.minX + rect.width * 4/5,
                        y: rect.minY + rect.height / 8),
            control1: CGPoint(x: rect.minX + rect.width * 1/2 + sqbx,
                              y: rect.minY + rect.height / 8 + sqby),
            control2: CGPoint(x: rect.minX + rect.width * 4/5 - sqbx,
                              y: rect.minY + rect.height / 8 + sqby)
        )
        upper.addCurve(
            to: CGPoint(x: rect.minX + rect.width,
                        y: rect.minY + rect.height / 2),
            control1: CGPoint(x: rect.minX + rect.width * 4/5 + sqbx,
                              y: rect.minY + rect.height / 8 - sqby),
            control2: CGPoint(x: rect.minX + rect.width,
                              y: rect.minY)
        )
        
        var lower = upper
        lower = lower.applying(CGAffineTransform.identity.rotated(by: CGFloat.pi))
        lower = lower.applying(CGAffineTransform.identity.translatedBy(x: rect.size.width, y: rect.size.height))
        upper.move(to: CGPoint(x: rect.minX, y: rect.midY))
        upper.addPath(lower)
        
        return upper
    }
}


struct Squiggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Squiggle().stroke(lineWidth: 5)
            Squiggle().fillAndBorder(5)
            Squiggle().stripe(5)
            Squiggle().blur(5)
        }
        .foregroundColor(.red)
        .padding()
    }
}


