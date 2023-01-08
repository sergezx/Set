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
    static var countPlayers = 2

    
    private static func createSetGame() -> SetGame<SetCard> {
        return SetGame<SetCard>( numberOfCardsInDeck: deckSetting.cards.count, numberOfCardsStart: numberOfCardsStart, countPlayers: countPlayers ) { index in
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

    var players: Array<Player> {
        return model.players
    }
    
    var hintsCount: Int {
        return model.hints.count
    }

    var numberHint: Int {
        return model.numberHint
    }

    var numberOfCurrentPlayer: Int {
        return model.numberOfCurrentPlayer
    }
        
    // MARK: - Intent(s)
    
    func deal() {
        model.deal(3)
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

// Here will be my thoughts on the timer in the Game

class StopWatchManager {
    var secondsElapsed = 0.0
    var timer = Timer()
    
    func start() {
          timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
              self.secondsElapsed += 0.1
          }
      }
}
