//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Sergey on 06.12.2022.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init (items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                let width: CGFloat = widthThatFirst(itemCount: items.count, in: geometry.size, itemAspectRaio: aspectRatio)
                ScrollView{
                    LazyVGrid(columns: [adaptiveGrideItem(width: width)], spacing: 0){
                        ForEach(items) { item in
                            content(item).aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            
        }
    }
    
    private func adaptiveGrideItem (width: CGFloat) -> GridItem {
        let minWidth: CGFloat = 65
        //        var gridItem = GridItem(.adaptive(minimum: width))
        var gridItem = GridItem(.adaptive(minimum: width>minWidth ? width : minWidth))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFirst(itemCount: Int, in size: CGSize, itemAspectRaio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRaio
            if CGFloat (rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
