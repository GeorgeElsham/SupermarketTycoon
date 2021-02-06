//
//  Upgrades.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 06/02/2021.
//

import Foundation


/// Different types of upgrades available.
enum Upgrade: String, CaseIterable, Identifiable {
    case advertising = "Advertising"
    case checkouts = "Checkouts"
    case stock = "Stock"
    
    var id: String { rawValue }
}
