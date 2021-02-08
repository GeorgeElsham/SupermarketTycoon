//
//  ShoppingItem.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 26/01/2021.
//

import SpriteKit
import SwiftUI


class ShoppingItem {
    let item: FoodItem
    let quantityRequired: Int
    private(set) var quantityObtained: Int
    
    var isObtained: Bool {
        quantityObtained == quantityRequired
    }
    
    var color: Color {
        if quantityObtained == 0 {
            return .red
        } else if quantityObtained < quantityRequired {
            return .orange
        } else {
            return .green
        }
    }
    
    init() {
        item = FoodItem.allCases.randomElement()!
        quantityRequired = Int.random(in: 1 ... 5)
        quantityObtained = 0
    }
    
    func getItem() {
        guard quantityObtained < quantityRequired else {
            fatalError("Added more items than required. \(quantityObtained)/\(quantityRequired).")
        }
        quantityObtained += 1
    }
}


enum FoodItem: CaseIterable {
    struct ItemName {
        let singular: String
        let plural: String
        
        init(singular: String, plural: String) {
            self.singular = singular
            self.plural = plural
        }
        init(both: String) {
            singular = both
            plural = both
        }
    }
    
    case meat
    case milk
    case baguette
    case bun
    case orange
    case apple
    
    var name: ItemName {
        switch self {
        case .meat:     return ItemName(both: "Meat")
        case .milk:     return ItemName(both: "Milk")
        case .baguette: return ItemName(singular: "Baguette", plural: "Baguettes")
        case .bun:      return ItemName(singular: "Bun", plural: "Buns")
        case .orange:   return ItemName(singular: "Orange", plural: "Oranges")
        case .apple:    return ItemName(singular: "Apple", plural: "Apples")
        }
    }
    var nodes: [Int] {
        switch self {
        case .meat:     return [14, 15]
        case .milk:     return [23, 24]
        case .baguette: return [17, 18]
        case .bun:      return [25, 26]
        case .orange:   return [20, 21]
        case .apple:    return [27, 28]
        }
    }
}
