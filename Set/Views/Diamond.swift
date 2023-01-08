//
//  Diamond.swift
//  Set
//
//  Created by Sergey on 07.12.2022.
//

import SwiftUI

//Capsule() - используем для рисования овала


struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let top = CGPoint (x: rect.midX, y: rect.minY)
        let left = CGPoint (x: rect.minX, y: rect.midY)
        let buttom = CGPoint (x: rect.midX, y: rect.maxY)
        let right = CGPoint (x: rect.maxX, y: rect.midY)
        
        path.move(to: top)
        path.addLine(to: left)
        path.addLine(to: buttom)
        path.addLine(to: right)
        path.addLine(to: top)

        return path
    }
}


struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Diamond().stroke(lineWidth: 5)
            Diamond().fill()
            ZStack{
                Diamond().opacity(0.5)
                Diamond().stroke(lineWidth: 5)
            }
        }
        .foregroundColor(.red)
        .padding()
    }
}
