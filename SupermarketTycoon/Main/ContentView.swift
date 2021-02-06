//
//  ContentView.swift
//  SupermarketTycoon
//
//  Created by George Elsham on 03/12/2020.
//

import SwiftUI


/// Holds all app content.
struct ContentView: View {
    
    @ObservedObject private var state = AppState()
    
    var body: some View {
        switch state.screen {
        case .menu:
            MenuView()
                .addMenuButton()
                .baseBackground()
                .environmentObject(state)
            
        case .game:
            GameView()
                .addMenuButton()
                .environmentObject(state)
            
        case .instructions:
            InstructionsView()
                .addMenuButton()
                .baseBackground()
                .environmentObject(state)
            
        case .leaderBoard:
            Text("Leader board")
                .foregroundColor(.black)
                .addMenuButton()
                .baseBackground()
                .environmentObject(state)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
//            .environment(
//                \.managedObjectContext,
//                PersistenceController.preview.container.viewContext
//            )
    }
}
