//
//  AppState.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import AppKit


/// Stores the states for the app.
class AppState: ObservableObject {
    
    enum Screen {
        case menu
        case game
        case instructions
        case leaderBoard
    }
    
    @Published private(set) var screen: Screen = .menu
    
    func change(to screen: Screen) {
        self.screen = screen
    }
}


extension AppState {
    
    /// The sidebar may not be showing, so a button in the toolbar is used to toggle it.
    static func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
