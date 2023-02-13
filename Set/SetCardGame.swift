//
//  SetGameViewModel.swift
//  SetV2
//
//  Created by Sergey on 12.12.2022.
//

import SwiftUI

class SetCardGame: ObservableObject {
    typealias Card = SetGame<SetCard>.Card
    static var deckSetting = SetCardDeck()
    static var numberOfCardsStart = 12
    static var playersCount = 2
    static var numberCardsForDeal = 3

    private static func createSetGame() -> SetGame<SetCard> {
        deckSetting.shuffle()
        return SetGame<SetCard>( numberOfCardsInDeck: deckSetting.cards.count, playersCount: playersCount ) { index in
            deckSetting.cards[index]
        }
    }
    
    @Published private var model = createSetGame()

    // MARK: - Access to the model

    var cards: Array<Card> {
        return model.cards
    }

    var deck: Array<Card> {
        return model.deck
    }
    
    var discardPile: Array<Card> {
        return model.discardPile
    }

    var players: Array<Player> {
        return model.players
    }
    
    var hintsCount: Int {
        return model.hints.count
    }

    var numberHint: Int {
        return model.hintNumber
    }

    var numberOfCurrentPlayer: Int {
        return model.numberOfCurrentPlayer
    }

    
    // MARK: - Intent(s)
    
    func dealCards() -> [Card] {
        model.dealCards(cards.isEmpty ? SetCardGame.numberOfCardsStart : SetCardGame.numberCardsForDeal)
        return model.cards
    }
    
    func flipOver(_ card: Card) {
        model.flipOver(card)
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
        
    func newGame() {
        model = SetCardGame.createSetGame()
    }

    func cheat() {
        model.cheat()
    }
    
    func changePlayer() {
        model.changePlayer()
    }
}
