//
//  GameScene.swift
//  Supermarket Tycoon
//
//  Created by George Elsham on 09/12/2020.
//

import SpriteKit


/// `SpriteKit` game scene.
class GameScene: SKScene {
    
    let debugMode: Bool = true
    private(set) var money: Int = 0
    var center: CGPoint {
        CGPoint(x: frame.midX, y: frame.midY)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupAll()
        
        let person = SKSpriteNode(imageNamed: "person_customer")
        person.position = center
        person.zPosition = 0
        addChild(person)
        
        if debugMode {
            displayGraph()
        }
    }
}


extension CGPoint {
    
    /// Scales coordinates of the standard scene size to fit the whole scene size.
    /// - Parameter size: Size of scene.
    /// - Returns: New scaled point.
    func scale(toFit size: CGSize) -> CGPoint {
        let originalSize = CGSize(width: 1440, height: 900)
        let ratio = size.width / originalSize.width
        let newSize = CGPoint(x: x * ratio, y: y * ratio)
        return newSize
    }
}
