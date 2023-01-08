//
//  ShapeExtension.swift
//  Set
//
//  Created by Sergey on 08.12.2022.
//

import SwiftUI

struct StripedRect: Shape {
    var spacing: CGFloat = 5
    
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.minX, y: rect.minY)
        var path = Path()
        
        path.move(to: start)
        
        while path.currentPoint!.x < rect.maxX {
            path.addLine(to: CGPoint(x: path.currentPoint!.x, y: rect.maxY))
            path.move(to: CGPoint(x: path.currentPoint!.x + spacing, y: rect.minY))
        }
        return path
    }
}
  
extension Shape {
    func stripe (_ lineWidth: CGFloat = 2) -> some View {
        ZStack{
            StripedRect().stroke().clipShape(self)
            self.stroke(lineWidth: lineWidth)
        }
    }
    func blur (_ lineWidth: CGFloat = 2) -> some View {
        ZStack {
            self.opacity(0.5)
            self.stroke(lineWidth: lineWidth)
        }
    }
    func fillAndBorder (_ lineWidth: CGFloat = 2) -> some View {
        ZStack {
            self.stroke(lineWidth: lineWidth)
            self.fill()
        }
    }
}
