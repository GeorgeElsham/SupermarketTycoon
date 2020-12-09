//
//  AppView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SwiftUI


/// Template for every screen of the app.
struct AppView<Main: View, Sidebar: View>: View {
    
    private let main: () -> Main
    private let sidebar: () -> Sidebar
    
    init(@ViewBuilder main: @escaping () -> Main, @ViewBuilder sidebar: @escaping () -> Sidebar) {
        self.main = main
        self.sidebar = sidebar
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                sidebar()
                    .frame(width: geo.size.width - (geo.size.height * 1.6))
                
                main()
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


struct AppView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppView {
            Text("Main")
        } sidebar: {
            Text("Sidebar")
        }
    }
}
