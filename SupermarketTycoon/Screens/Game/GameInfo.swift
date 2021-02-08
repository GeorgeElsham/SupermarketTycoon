//
//  GameInfo.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 06/02/2021.
//

import SpriteKit
import SwiftUI


// MARK: - C: GameInfo
/// Stores the information about the game, such as if it is paused or the money available.
class GameInfo {
    
    var customers = [CustomerNodeGroup]()
    let outsideData: OutsideData
    
    /// Whether the game is paused.
    private(set) var isPaused: Bool {
        didSet {
            GameView.scene.isPaused = isPaused
        }
    }
    /// Money player has available.
    private(set) var money: Int {
        didSet {
            GameView.scene.balanceLabel.text = formattedMoney
        }
    }
    /// Existing checkouts in the store.
    private(set) var checkouts: [Checkout]
    
    init(outsideData: OutsideData) {
        self.outsideData = outsideData
        isPaused = false
        money = 0
        checkouts = []
    }
    
    func setup() {
        checkouts.append(Checkout(number: 1))
    }
}


// MARK: Ext: Play/pause
extension GameInfo {
    func playGame() {
        isPaused = false
    }
    
    func pauseGame() {
        isPaused = true
    }
}


// MARK: Ext: Money
extension GameInfo {
    enum MoneyError: Error {
        case insufficientFunds
    }
    
    var formattedMoney: String {
        "£\(money)"
    }
    
    func addMoney(amount: Int) {
        money += amount
    }
    
    func removeMoney(amount: Int) throws {
        guard money >= amount else {
            throw MoneyError.insufficientFunds
        }
        money -= amount
    }
}


// MARK: Ext: Checkouts
extension GameInfo {
    func priceOfCheckout(number: Int) -> Int {
        number * 50 - 50
    }
    
    func unlockNextCheckout() throws {
        // Get price
        let nextCheckoutNumber = checkouts.count + 1
        let price = priceOfCheckout(number: nextCheckoutNumber)
        
        // Try purchase
        try removeMoney(amount: price)
        checkouts.append(Checkout(number: nextCheckoutNumber))
    }
}
