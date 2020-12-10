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
                .environmentObject(state)
            
        case .game:
            GameView()
                .environmentObject(state)
            
        case .instructions:
            InstructionsView()
                .environmentObject(state)
            
        default:
            AppView {
                Text("Unavailable")
            }
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
