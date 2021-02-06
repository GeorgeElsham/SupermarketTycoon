//
//  Checkout.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 06/02/2021.
//

import SpriteKit


/// Checkouts in the middle of the store, for customers to purchase items.
class Checkout {
    enum Side: String {
        case left
        case right
    }
    
    private static let checkoutPositions: [(side: Side, x: CGFloat)] = [
        (.right, 858),
        (.left, 582),
        (.left, 1105),
        (.right, 335),
        (.right, 1278),
        (.left, 162)
    ]
    
    init(number: Int) {
        // Get checkout positions
        let positions = Checkout.checkoutPositions[number - 1]
        
        // Create sprite node
        let texture = SKTexture(imageNamed: "checkout_\(positions.side.rawValue)")
        let size = Scaling.size(texture.size())
        let checkoutNode = SKSpriteNode(texture: texture, size: size)
        checkoutNode.position = Scaling.point(CGPoint(x: positions.x, y: 415))
        checkoutNode.zPosition = ZPosition.checkout.rawValue
        GameView.scene.addChild(checkoutNode)
    }
}
