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
    
    let outsideData: OutsideData
    var customers = [CustomerNodeGroup]()
    var time: (m: Int, s: Int) = (3, 0) {
        didSet {
            if time == (0, 0) {
                outsideData.hasEnded = true
            }
        }
    }
    
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
            outsideData.money = money
        }
    }
    /// Existing checkouts in the store.
    private(set) var checkouts: [Checkout] {
        didSet {
            outsideData.checkouts = checkouts.count
        }
    }
    
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
    enum GameInfoError: Error {
        case insufficientFunds
        case enoughCheckouts
    }
    
    var formattedMoney: String {
        "£\(money)"
    }
    
    func addMoney(amount: Int) {
        money += amount
    }
    
    func removeMoney(amount: Int) throws {
        guard money >= amount else {
            throw GameInfoError.insufficientFunds
        }
        money -= amount
    }
}


// MARK: Ext: Checkouts
extension GameInfo {
    func priceOfCheckout(number: Int) -> Int {
        number * 50 - 50
    }
    
    func priceOfNextCheckout() -> Int {
        priceOfCheckout(number: checkouts.count + 1)
    }
    
    func unlockNextCheckout() throws {
        // Make sure there is a maximum of 6 checkouts
        guard checkouts.count < 6 else {
            throw GameInfoError.enoughCheckouts
        }
        
        // Get price
        let nextCheckoutNumber = checkouts.count + 1
        let price = priceOfCheckout(number: nextCheckoutNumber)
        
        // Try purchase
        try removeMoney(amount: price)
        checkouts.append(Checkout(number: nextCheckoutNumber))
    }
}
