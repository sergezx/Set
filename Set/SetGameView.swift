//
//  SetGameView.swift
//  SetV2
//
//  Created by Sergey on 12.12.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: SetCardGame
    
    @Namespace private var dealingNamespace
    @Namespace private var discardingNamespace
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack {
                    score
                    gameBody
                    Spacer()
                    HStack{
                        cheat
                        Spacer()
                        changePlayer
                    }
                    .padding(.horizontal)
                }
                HStack {
                    Group {
                        discardPile
                        Spacer()
                        deckBody
                    }
                    .frame(width: CardConstants.undealWidth, height: CardConstants.undealHeight)
                    .foregroundColor(CardConstants.color)
                }
            }
            //            .padding()
            .toolbar {
                Button("New Game") {
                    withAnimation  {
                        dealt = []
                        game.newGame()
                        CardConstants.offsetHeight = -3
                    }
                }
            }
            .navigationBarTitle("Set Game!")
        }
    }
    
    @State private var dealt = Set<Int>()
    @State private var dropped = Set<Int>()
    
    private func deal(_ card: SetCardGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: SetCardGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func addCardToDiscard(_ card:SetCardGame.Card) {
        dropped.insert(card.id)
    }
    
    private func discardWithAnimation() {
        let delay = 2.0
        for card in game.cards.filter({$0.isMatched == true}) {
            withAnimation(Animation.easeInOut(duration: 2).delay(delay)) {
                addCardToDiscard(card)
            }
        }
    }
    
    private func dealWithAnimation() {
        var delay = 0.0
        
        for card in game.dealCards() {
            if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
                delay = Double(index<SetCardGame.numberOfCardsStart ? index : (index+SetCardGame.numberCardsForDeal)-game.cards.count) * (CardConstants.totaldealDuration / Double(game.cards.count))
            }
            
            withAnimation(Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)) {
                deal(card)
            }
            withAnimation((Animation.easeIn(duration: CardConstants.FlipOverAnimationDuration)).delay(delay+CardConstants.FlipOverDelay)) {
                game.flipOver(card)
            }
        }
    }
    
    private func zIndex(of card: SetCardGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    private func offset() -> Int {
        if CardConstants.offsetHeight >= 9 {
            CardConstants.offsetHeight = 9
        } else  {
            CardConstants.offsetHeight+=3
        }
        return CardConstants.offsetHeight
    }
    
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                        discardWithAnimation() // тут просто нужно вызывать фукнцию, где добавляем карты в сброс
                    }
            }
        }
        .foregroundColor(CardConstants.color )
        .padding(.horizontal)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(of: card))
                    .offset(CGSize(width: -offset(), height: -CardConstants.offsetHeight))
            }
        }
        .onTapGesture {
            dealWithAnimation()
            CardConstants.offsetHeight = -3
        }
    }
    
    var discardPile: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
            }
        }
    }
    
    var cardDeck: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
            shape.fill()
            shape.strokeBorder(lineWidth: CardConstants.lineWidth)
        }
        .frame(width: CardConstants.undealWidth, height: CardConstants.undealHeight)
        .foregroundColor(CardConstants.color)
    }
    
    var score: some View {
        ZStack{
            Text("Score \(game.numberOfCurrentPlayer + 1):  \(game.players[game.numberOfCurrentPlayer].score)")
                .bold().padding(.bottom)
        }
    }
    
    // Buttons
    var cheat: some View {
        HStack{
            Button("Cheat \(game.numberHint) / \(game.hintsCount)")
            {
                withAnimation  {
                    game.cheat()
                }
            }
        }
    }
    var changePlayer: some View {
        HStack{
            Button("\(game.players[game.numberOfCurrentPlayer].name)")
            {
                withAnimation  {
                    game.changePlayer()
                }
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totaldealDuration: Double = 2
        static let undealHeight: CGFloat = 90
        static let undealWidth = undealHeight * aspectRatio
        static let FlipOverAnimationDuration: CGFloat = 0.7
        static let FlipOverDelay: CGFloat = 0.7
        
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1
        static let colorDiscardPilesLine : Color = .black
        static var offsetHeight: Int = -3
        static var offsetWeight: Int = offsetHeight
        
    }
}



/*
 struct SetCard: Matchable { // CardConfiguration
 let shape: Variant
 let fill: Variant
 let color: Variant
 let count: Variant
 
 enum Variant: Int, CaseIterable {
 case v1 = 1
 case v2
 case v3
 
 var color: Color {
 switch self {
 case .v1: return .red
 case .v2: return .green
 case .v3: return .purple
 }
 }
 var shape: Color {
 switch self {
 case .v1: return .red
 case .v2: return .green
 case .v3: return .purple
 }
 }
 }
 }
 SetCard.shape
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetCardGame()
        ContentView(game: game).preferredColorScheme(.light)
        ContentView(game: game).preferredColorScheme(.dark)
    }
}
