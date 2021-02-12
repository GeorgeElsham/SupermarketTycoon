//
//  SupermarketTycoonApp.swift
//  SupermarketTycoon
//
//  Created by George Elsham on 03/12/2020.
//

import SwiftUI


@main
struct SupermarketTycoonApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
        }
        .commands {
            SidebarCommands()
        }
    }
}
