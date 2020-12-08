//
//  ContentView.swift
//  SupermarketTycoon
//
//  Created by George Elsham on 03/12/2020.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                SidebarView()
                    .frame(width: geo.size.width - (geo.size.height * 1.6))
                
                MenuView()
                    .frame(width: geo.size.height * 1.6)
            }
        }
        .toolbar {
            Button("Toggle sidebar") {
                toggleSidebar()
            }
        }
    }
    
    /// The sidebar may not be showing, so a button in the toolbar is used to toggle it.
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
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
