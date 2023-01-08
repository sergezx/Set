//
//  SetGameModel.swift
//  SetV2
//
//  Created by Sergey on 12.12.2022.
//

import Foundation

protocol Matchable {
    static func match(cards: [Self]) -> Bool?
}

struct SetGame<CardContent> where CardContent: Matchable {
    
    private(set) var cards = [Card]()
    private(set) var deck = [Card]() {
        willSet {
            countHints()
        }
    }
    private var selectedCardsIndices: [Int] {cards.indices.filter {cards[$0].isChoosen}}
    private var isMatchedCards: [Int] {cards.indices.filter {cards[$0].isMatched == true}}
    private(set) var cardsWasMatch: Bool?

    private(set) var hints = [[Int]]()
    private(set) var numberHint = 0

    private(set) var timeLastThreeCardsWereChosen = Date() {
        didSet {
            spentTimeFunc(timeHasPassed: Int(timeLastThreeCardsWereChosen.timeIntervalSince(oldValue)))
        }
    }
    private(set) var timeSpent: Int = 0

    private(set) var countPlayers: Int
    private(set) var players = [Player]()
    private(set) var numberOfCurrentPlayer = 0
        
    init(numberOfCardsInDeck: Int, numberOfCardsStart: Int, countPlayers: Int, cardContentFactory: (Int) -> CardContent) {
        self.countPlayers = countPlayers
        for index in 0..<numberOfCardsInDeck {
            let content = cardContentFactory(index)
            deck.append(Card(id: index, content: content))
        }
        deck.shuffle()
        deal(numberOfCardsStart)
        for i in 0..<countPlayers {
            players.append(Player(name: "Player \(i + 1)"))
        }
    }

    mutating func choose(_ card: Card) {
        if let chooosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            cards[chooosenIndex].isChoosen.toggle()
            if cardsWasMatch != nil {
                if cardsWasMatch == true { deal(3) }
                resetCardProperties(chooosenIndex)
            }
            cardsWasMatch = CardContent.match(cards: selectedCardsIndices.map {cards[$0].content}) ?? nil
            for index in selectedCardsIndices {
                cards[index].isMatched = cardsWasMatch
            }
            scoring()
        }
    }
    
    mutating func deal(_ numberOfCards: Int = 0) {
        for _ in 0..<numberOfCards {
            if let index = isMatchedCards.sorted(by: >).first {
                if deck.count > 0 {
                    cards[index] = deck.remove(at: 0)
                } else {
                    cards.remove(at: index)
                }
            }
            else if deck.count > 0 {
                cards.append(deck.remove(at: 0))
            }
            cardsWasMatch = CardContent.match(cards: selectedCardsIndices.map {cards[$0].content}) ?? nil
        }
        if (numberOfCards == 3 && selectedCardsIndices.count < 3 && selectedCardsIndices.count != 1 && !hints.isEmpty) {
            players[numberOfCurrentPlayer].score -= 1
        }
    }
    
/*
    mutating func changeCards(){
        for index in isMatchedCards.sorted(by: >) {
            if deck.count >= isMatchedCards.count {
                cards[index] = deck.remove(at: 0)
            } else {
                cards.remove(at: index)
            }
        }
    }
*/
   
    mutating func cheat() {
        deCheat()
        if cardsWasMatch == true {
            deal(3)
            cardsWasMatch = CardContent.match(cards: selectedCardsIndices.map {cards[$0].content}) ?? nil
        }
        countHints()
        if numberHint >= hints.count { numberHint = 0}
        if hints.count > 0 {
            for index in hints[numberHint] {
                cards[index].isHint = true
            }
            numberHint += 1
        }
    }
    
    mutating func deCheat() {
        for index in 0..<cards.count {
            cards[index].isChoosen = false
            cards[index].isHint = false
        }
    }
    
    mutating func scoring() {
        if cardsWasMatch == true {
            timeLastThreeCardsWereChosen = Date()
            players[numberOfCurrentPlayer].score += max(Int(20/timeSpent),2)
        } else if cardsWasMatch == false {
            players[numberOfCurrentPlayer].score -= 1
        }
    }
    
    mutating func resetCardProperties(_ exceptIndex: Int? = nil) {
        for index in 0..<cards.count {
            if index != exceptIndex {
                cards[index].isChoosen = false
                cards[index].isMatched = nil
                cards[index].isHint = false
            }
        }
    }
        

    mutating func countHints () {
        hints = [[Int]]()
        if cards.count > 2 {
            for i in 0..<cards.count  - 2 {
                for j in (i+1)..<cards.count - 1 {
                    for k in (j+1)..<cards.count {
                        let checkList = [cards[i], cards[j], cards[k]]
                        if CardContent.match(cards: checkList.map { $0.content }) == true {
                            hints.append([i,j,k])
                        } // match
                    } // k
                } // j
            } // i
        } // >2
    }
    
    mutating func spentTimeFunc (timeHasPassed: Int) {
        timeSpent = timeHasPassed
    }

    mutating func changePlayer () {
        if numberOfCurrentPlayer == countPlayers-1 {
            numberOfCurrentPlayer = 0
        } else {
            numberOfCurrentPlayer += 1
        }
        
        timeLastThreeCardsWereChosen = Date()
        resetCardProperties()
    }
    
    struct Card: Identifiable {
        var isChoosen =  false
        var isMatched: Bool?
        var isHint = false
        let id: Int
        let content : CardContent
    }
}

struct SetCard: Matchable { // CardConfiguration
    let shape: Variant
    let fill: Variant
    let color: Variant
    let count: Variant
    
    enum Variant: Int, CaseIterable {
        case v1 = 1
        case v2
        case v3
    }
    
    static func match(cards: [SetCard]) -> Bool? {
        guard cards.count == 3 else {return nil}
        let sum: [Int]
        sum = [
            cards.reduce(0, {$0 + $1.shape.rawValue}),
            cards.reduce(0, {$0 + $1.fill.rawValue}),
            cards.reduce(0, {$0 + $1.color.rawValue}),
            cards.reduce(0, {$0 + $1.count.rawValue})
        ]
        return sum.reduce(true, {$0 && ($1 % 3 == 0)})
    }
}

struct SetCardDeck {
    private(set) var cards = [SetCard]()
    init () {
        for count in SetCard.Variant.allCases {
            for color in SetCard.Variant.allCases {
                for fill in SetCard.Variant.allCases {
                    for shape in SetCard.Variant.allCases {
                        cards.append(
                            SetCard(
                                shape: shape,
                                fill: fill,
                                color: color,
                                count: count
                            )
                        )
                    }
                }
            }
        }
        cards.shuffle()
    }
}

struct Player {
    var name: String = "Player 1"
    var score: Int = 0
}

