//
//  Ext-Text.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 06/02/2021.
//

import SwiftUI


extension Text {
    /// Underline text based on a condition.
    func underline(if condition: Bool) -> Text {
        condition ? underline() : self
    }
    
    /// Large font for sidebar titles.
    func bigTitle() -> some View {
        self
            .font(.system(size: 40))
            .fontWeight(.bold)
            .foregroundColor(.black)
    }
}
