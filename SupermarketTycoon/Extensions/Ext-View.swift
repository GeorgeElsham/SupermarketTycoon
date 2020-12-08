//
//  Ext-View.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 08/12/2020.
//

import SwiftUI


extension View {
    
    func run(_ action: @escaping () -> Void) -> Self {
        action()
        return self
    }
}
