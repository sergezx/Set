//
//  SetGameView.swift
//  SetV2
//
//  Created by Sergey on 12.12.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: SetCardGame

    var body: some View {
        NavigationView {
            VStack {
                Text("Score \(game.numberOfCurrentPlayer + 1):  \(game.players[game.numberOfCurrentPlayer].score)")
                    .bold().padding(.bottom)
                AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                    CardView(card: card)
                        .padding(4)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
                .padding(.horizontal)
                Spacer()
                HStack{
                    Spacer()
                    VStack{
                        Text("\(game.deck.count)")
                            .font(.largeTitle)
                        Text("Deck")
                    }
                    Spacer()
                    cheat
                    Spacer()
                    deal.disabled(game.deck.isEmpty ? true : false)
                    Spacer()
                }
                HStack {
                    changePlayer
                }

            }
            .padding(.horizontal)
            .toolbar {
                Button("New Game") {
                    game.newGame()
                }
            }
            .navigationBarTitle("Set Game!")
        }
    }

// Buttons
    var deal: some View {
        HStack{
            Button("Deal +3")
            { game.dealCards() }
                .font(.title3)
                .roundButtonStyle(colorButton: .purple)
        }
    }
    var cheat: some View {
        HStack{
            Button("Cheat \(game.numberHint) / \(game.hintsCount)")
            { game.cheat() }
                .font(.title3)
                .roundButtonStyle(colorButton: .purple)
        }
    }
    var changePlayer: some View {
        HStack{
            Button("\(game.players[game.numberOfCurrentPlayer].name)")
            { game.changePlayer() }
                .roundButtonStyle(colorButton: .green)
//                .onReceive(<#T##publisher: Publisher##Publisher#>, perform: <#T##(Publisher.Output) -> Void#>)
        }
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
