//
//  HP_TriviaApp.swift
//  HP Trivia
//
//  Created by Ishaan Das on 21/06/24.
//

import SwiftUI

@main
struct HP_TriviaApp: App {
    @StateObject private var store = Store()
    @StateObject private var game = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(store)
                .environmentObject(game)
                .task {
                    await store.loadProducts()
                }
        }
    }
}
