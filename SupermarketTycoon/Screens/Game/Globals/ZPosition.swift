//
//  ZPosition.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 06/02/2021.
//

import Foundation


/// Depths of each node type.
enum ZPosition: CGFloat {
    case background = -1
    case checkout = 1.5
    case debugLine = 2.4
    case debugNode = 2.5
    case customer = 5
}
