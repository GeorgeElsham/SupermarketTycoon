//
//  ContentView.swift
//  SupermarketTycoon
//
//  Created by George Elsham on 03/12/2020.
//

import SwiftUI


/// Holds all app content.
struct ContentView: View {
    
    @State private var state: AppState = .menu
    
    var body: some View {
        switch state {
        case .menu:
            MenuView(state: $state)
        case .game:
            GameView()
        default:
            AppView {
                Text("Unavailable")
            } sidebar: {
                EmptyView()
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
