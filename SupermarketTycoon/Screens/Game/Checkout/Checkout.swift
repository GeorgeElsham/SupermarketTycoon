//
//  Checkout.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 06/02/2021.
//

import SpriteKit


// MARK: - C: Checkout
/// Checkouts in the middle of the store, for customers to purchase items.
class Checkout {
    enum QueueError: Error {
        case alreadyFull
        case didNotReserve
    }
    
    enum Side: String {
        case left
        case right
    }
    
    struct Position {
        let side: Side
        let node: Int
        let x: CGFloat
    }
    
    struct QueueItem {
        let customer: Customer
        var isWaiting: Bool
    }
    
    private static let purchaseItemTime: Double = 0.5
    private static let checkoutPositions: [Position] = [
        Position(side: .right, node: 5, x: 858),
        Position(side: .left, node: 4, x: 582),
        Position(side: .left, node: 6, x: 1105),
        Position(side: .right, node: 3, x: 335),
        Position(side: .right, node: 7, x: 1278),
        Position(side: .left, node: 2, x: 162)
    ]
    
    let number: Int
    let node: Int
    private(set) var queue: [QueueItem] = []
    private let checkoutNode: SKSpriteNode
    
    init(number: Int) {
        self.number = number
        
        // Get checkout positions
        let positions = Checkout.checkoutPositions[number - 1]
        node = positions.node
        
        // Create sprite node
        let texture = SKTexture(imageNamed: "checkout_\(positions.side.rawValue)")
        let size = Scaling.size(texture.size())
        checkoutNode = SKSpriteNode(texture: texture, size: size)
        checkoutNode.position = Scaling.point(CGPoint(x: positions.x, y: 415))
        checkoutNode.zPosition = ZPosition.checkout.rawValue
        GameView.scene.addChild(checkoutNode)
        
        // Create cashier
        let cashier = SKSpriteNode(imageNamed: "person_cashier")
        cashier.position = CGPoint(x: positions.side == .left ? 27 : -27, y: 0)
        checkoutNode.addChild(cashier)
        
        // Animate cashier bounce
        let bounceUp = SKAction.moveTo(y: 2, duration: 1)
        let bounceDown = SKAction.moveTo(y: -2, duration: 1)
        bounceUp.timingMode = .easeInEaseOut
        bounceDown.timingMode = .easeInEaseOut
        let bounce = SKAction.sequence([bounceUp, bounceDown])
        cashier.run(.repeatForever(bounce))
    }
    
    /// Get the index of the checkout in the `GameInfo` `checkouts` array.
    /// - Parameter node: Equivalent path node.
    /// - Returns: Index of checkout. Effectively the index is one less than the checkout number.
    static func indexOfCheckout(at node: Int) -> Int {
        guard let index = checkoutPositions.firstIndex(where: { $0.node == node }) else {
            fatalError("Cannot find index of node '\(node)'.")
        }
        return index
    }
    
    /// Reserves a customer's space in the queue. This is used so the queue
    /// doesn't become full by the time they path-find to the checkouts.
    /// - Parameter customer: Customer to reserve queue space for.
    /// - Throws: Error if the customer cannot be added to the queue.
    func reservePlaceInQueue(_ customer: Customer) throws {
        // Make sure there is space in the queue
        guard queue.count < 3 else {
            throw QueueError.alreadyFull
        }
        
        // Add to queue
        queue.append(QueueItem(customer: customer, isWaiting: false))
    }
    
    /// Adds customer to back of queue.
    /// - Parameter customer: Customer object to keep as a reference in the queue.
    func addCustomerToQueue(_ customer: Customer) throws {
        // If first, start processing
        guard let index = queue.firstIndex(where: { $0.customer == customer }) else {
            throw QueueError.didNotReserve
        }
        queue[index].isWaiting = true
        
        // Process or move
        if index == 0 {
            processFirstInQueue(for: customer)
        } else {
            updateQueuePositions()
        }
    }
    
    /// First customer in queue processes purchase, then leaves the store.
    func processFirstInQueue(for customer: Customer?) {
        // Get first customer
        guard let firstCustomer = queue.first?.customer else {
            fatalError("Queue is empty when trying to process first in queue.")
        }
        
        // Move all down
        updateQueuePositions {
            // Debug colors
            if Global.debugMode {
                self.checkoutNode.colorBlendFactor = 0.5
                self.checkoutNode.color = .red
            }
            
            // Get duration of checkout time
            let totalDuration = Double(firstCustomer.shoppingList.count) * Checkout.purchaseItemTime
            
            // Purchase all items
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) { [weak self] in
                // Pay and leave store
                guard let self = self else { return }
                
                // Debug colors
                if Global.debugMode {
                    self.checkoutNode.color = .green
                }
                
                // Finished in queue
                self.queue.removeFirst()
                let totalItemCount = firstCustomer.shoppingList.map(\.quantityRequired).reduce(0, +)
                GameView.scene.gameInfo.addMoney(amount: totalItemCount)
                firstCustomer.leaveStore(fromCheckouts: true)
                
                // Move to next in queue
                guard !self.queue.isEmpty && self.queue.first!.isWaiting == true else { return }
                self.processFirstInQueue(for: nil)
            }
        }
    }
    
    /// Move the customer's positions which are in the queue waiting.
    /// - Parameter completionForFirst: Completion handler ran when the first in queue has moved.
    private func updateQueuePositions(completionForFirst: @escaping () -> Void = {}) {
        for index in 0 ..< queue.count where queue[index].isWaiting {
            queue[index].customer.moveDownInQueue(to: index) {
                if index == 0 { completionForFirst() }
            }
        }
    }
}


// MARK: Ext: Comparable
extension Checkout: Comparable {
    static func < (lhs: Checkout, rhs: Checkout) -> Bool {
        lhs.queue.count < rhs.queue.count
    }
    
    static func == (lhs: Checkout, rhs: Checkout) -> Bool {
        lhs.queue.count == rhs.queue.count
    }
}
