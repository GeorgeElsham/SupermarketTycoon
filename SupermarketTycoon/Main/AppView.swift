//
//  AppView.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SwiftUI


/// Template for every screen of the app.
struct AppView<Main: View>: View {
    
    /// Type for the sidebar content, which may not exist.
    private enum SidebarType {
        case sidebar(AnyView)
        case none
    }
    
    @EnvironmentObject private var state: AppState
    
    private let main: () -> Main
    private let sidebar: SidebarType
    
    init<Sidebar: View>(@ViewBuilder main: @escaping () -> Main, @ViewBuilder sidebar: @escaping () -> Sidebar) {
        self.main = main
        self.sidebar = .sidebar(AnyView(sidebar()))
    }
    
    init(@ViewBuilder main: @escaping () -> Main) {
        self.main = main
        self.sidebar = .none
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                switch sidebar {
                case let .sidebar(sidebar):
                    sidebar
                        .frame(width: geo.size.width - (geo.size.height * 1.6))
                    
                    main()
                        .frame(width: geo.size.height * 1.6)
                    
                case .none:
                    ZStack(alignment: .bottom) {
                        Color("Background")
                        
                        Color("Grass")
                            .frame(height: geo.size.height * 19 / 90)
                    }
                    .frame(width: geo.size.width - (geo.size.height * 1.6))
                    
                    ZStack(alignment: .bottom) {
                        Color("Background")
                        
                        Color("Grass")
                            .frame(height: geo.size.height * 19 / 90)
                        
                        main()
                    }
                    .frame(width: geo.size.height * 1.6)
                }
            }
        }
        .toolbar {
            Button("Menu") {
                state.change(to: .menu)
            }
        }
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
