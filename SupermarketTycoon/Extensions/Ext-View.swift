//
//  Ext-View.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 08/12/2020.
//

import SwiftUI


// MARK: - View extension
extension View {
    
    func run(_ action: @escaping () -> Void) -> Self {
        action()
        return self
    }
    
    /// Add button at top in toolbar to return to the main menu.
    func addMenuButton() -> some View {
        ToolbarMenuButton(content: self)
    }
    
    /// Add the basic background to the current view.
    func baseBackground() -> some View {
        GeometryReader { geo in
            self
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    VStack(spacing: 0) {
                        Color("Background")
                        
                        Color("Grass")
                            .frame(height: geo.size.height * (19 / 90))
                    }
                )
        }
    }
}



// MARK: - S: ToolbarMenuButton
struct ToolbarMenuButton<Content: View>: View {
    
    @EnvironmentObject private var state: AppState
    private let content: Content
    
    init(content: Content) {
        self.content = content
    }
    
    var body: some View {
        content
            .toolbar {
                Button("Menu") {
                    state.change(to: .menu)
                }
            }
    }
}
