//
//  BackgroundBox.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 08/02/2021.
//

import SwiftUI


/// Box to display content in. Universal style across whole app.
struct BackgroundBox<Content: View>: View {
    
    private let content: () -> Content
    
    init(content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 1)
                    .background(
                        Color.white
                            .cornerRadius(15)
                    )
            )
    }
}
