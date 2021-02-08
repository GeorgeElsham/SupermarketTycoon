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
    enum Side: String {
        case left
        case right
    }
    
    struct Position {
        let side: Side
        let node: Int
        let x: CGFloat
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
    private(set) var queue: [Person] = []
    
    init(number: Int) {
        self.number = number
        
        // Get checkout positions
        let positions = Checkout.checkoutPositions[number - 1]
        node = positions.node
        
        // Create sprite node
        let texture = SKTexture(imageNamed: "checkout_\(positions.side.rawValue)")
        let size = Scaling.size(texture.size())
        let checkoutNode = SKSpriteNode(texture: texture, size: size)
        checkoutNode.position = Scaling.point(CGPoint(x: positions.x, y: 415))
        checkoutNode.zPosition = ZPosition.checkout.rawValue
        GameView.scene.addChild(checkoutNode)
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
    
    /// Adds person to back of queue.
    /// - Parameter person: Customer object to keep as a reference in the queue.
    func addPersonToQueue(_ person: Person) {
        queue.append(person)
    }
    
    /// First customer in queue processes purchase, then leaves the store.
    func processFirstInQueue() {
        // Get first person
        guard let firstPerson = queue.first else {
            fatalError("Queue is empty when trying to process first in queue.")
        }
        let totalDuration = Double(firstPerson.shoppingList.count) * Checkout.purchaseItemTime
        
        // Purchase all items
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) { [weak self] in
            guard let self = self else { return }
            self.queue.removeFirst()
            firstPerson.leaveStore()
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
