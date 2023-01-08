//
//  SetApp.swift
//  Set
//
//  Created by Sergey Zakharenko on 22.12.2022.
//

import SwiftUI

@main
struct SetApp: App {
    let game = SetCardGame()
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
