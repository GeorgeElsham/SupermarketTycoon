//
//  Ext-Text.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 06/02/2021.
//

import SwiftUI


extension Text {
    func underline(if condition: Bool) -> Text {
        condition ? underline() : self
    }
}
